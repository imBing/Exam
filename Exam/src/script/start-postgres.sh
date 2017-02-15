#! /bin/bash

IMG=postgres
VERSION=9.6
DB=one-auth
PASSWORD=thepassword
USER=one_auth_dev

if [ ! "$(docker images | grep $IMG | grep $VERSION)" ]
    then
        echo "Image $IMG has not been pulled. Start pulling $IMG ..."
	docker pull $IMG:$VERSION
fi

docker rm -f $DB > /dev/null

echo "starting postgres"

docker run \
       --name $DB \
       -p 5432:5432 \
       -e POSTGRES_DB=$DB \
       -e POSTGRES_USER=$USER \
       -e POSTGRES_PASSWORD=$PASSWORD \
       -d \
       $IMG:$VERSION

sleep 20

echo `docker inspect $DB | awk -F '"' '/IPAdd/ {print $4}' | sort -u`
