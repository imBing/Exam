#! /bin/bash

cmd=$1
POSTGRES_USER=${2:-"one_auth_dev"}
POSTGRES_SERVER=${3:-"localhost"}

if [[ $cmd = "setup" ]]; then
    python3 migrations/manage.py version_control postgresql://$POSTGRES_USER:thepassword@$POSTGRES_SERVER:5432/one-auth migrations
    exit $?
fi

if [[ $cmd = "migrate" ]]; then
    python3 migrations/manage.py upgrade --url postgresql://$POSTGRES_USER:thepassword@$POSTGRES_SERVER:5432/one-auth --repository migrations
    exit $?
fi
