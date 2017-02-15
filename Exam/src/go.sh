#! /bin/bash

cmd=$1

if [[ $cmd = "sa" ]]; then
    rm -rf src/**__pycache__**
    python3 -m pylint --rcfile=pylint.conf src/* --reports=n --disable=missing-docstring
    exit $?
fi

if [[ $cmd = "full-test" ]]; then
    /bin/bash go.sh start-db
    /bin/bash go.sh test
    exitcode_of_test=$?
    /bin/bash script/stop-postgres.sh
    exit $exitcode_of_test
fi

if [[ $cmd = "test" ]]; then
    python3 -m  nose test test/service --nologcapture
    exit $?
fi

if [[ $cmd = "coverage" ]]; then
    THRESHOLD=45
    python3 -m coverage run --source=src test/one_auth_test.py
    python3 -m coverage report --fail-under=$THRESHOLD
    exit $?
fi

if [[ $cmd = "coverage-strict" ]]; then
    latest=`curl http://tw-feedback-ci.chinacloudapp.cn/go/files/feedback-one-auth/latest/commit/latest/coverage/cruise-output/console.log | grep "TOTAL" | awk '{print $5}' | sed s/%//g`
    current=`/bin/bash go.sh coverage | grep TOTAL | awk '{print $4}' | sed s/%//g`
    echo "Latest: $latest"
    echo "Current: $current"
    if [[ $latest -gt $current ]]; then
	echo "Error: coverage reduced from $latest to $current"
	exit 2
    fi
fi

if [[ $cmd = "start-db" ]]; then
    /bin/bash script/start-postgres.sh
    /bin/bash script/db.sh setup
    /bin/bash script/db.sh migrate
    exit $?
fi

if [[ $cmd = "stop-db" ]]; then
    /bin/bash script/stop-postgres.sh
    exit $?
fi


if [[ $cmd = "remote-install"  ]]; then
    if [ $# -eq 3 ]; then
        user=$2
        host=$3
        /bin/bash script/install.sh $user $host
    else
        echo "please input the user and host (go.sh $cmd root 10.0.0.0)"
    fi
fi

if [[ $cmd = "install" ]]; then
    POSTGRES_DATABASE='one-auth'
    POSTGRES_PASSWORD='thepassword'
    POSTGRES_USER='one_auth_test'
    POSTGRES_URL='postgres:5432'
    docker build -t one-auth-dev .
    docker run --name one-auth-postgres-dev \
        -e POSTGRES_DB=$POSTGRES_DATABASE \
        -e POSTGRES_USER=$POSTGRES_USER \
        -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
        -d postgres:9.6
    sleep 10
    docker run --name one-auth-smtp-dev -d namshi/smtp
    docker run --name one-auth-dev \
        --link one-auth-postgres-dev:postgres \
        --link one-auth-smtp-dev:smtp \
        -e ONE_AUTH_ENV=production \
        -e DB_URL=$POSTGRES_URL \
        -e DB_USER_NAME=$POSTGRES_USER \
        -e DB_PASSWORD=$POSTGRES_PASSWORD \
        -p 8000:8000 \
        -d one-auth-dev
fi

if [[ $cmd = "uninstall" ]]; then
    docker rm -f one-auth-dev
    docker rm -f one-auth-postgres-dev
    docker rm -f one-auth-smtp-dev
fi

if [[ $cmd = "build" ]]; then
    /bin/bash script/build.sh
    exit $?
fi

if [[ $cmd == "help" ]]; then
    echo "Aviable subcommands: "
    cat go.sh | grep "^if" | grep 'cmd = ' | awk -F'cmd = ' '{print $2}' | awk -F']]' '{print $1}'
fi    
