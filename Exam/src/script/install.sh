#!/usr/bin/env bash

user=$1
host=$2
DOCKER_REGISTRY="tw.chinacloudapp.cn:5000"

API_NAME=one-auth-api
API_IMAGE="one-auth:$GO_PIPELINE_COUNTER"
POSTGRES_NAME=one-auth-postgres
SMTP_NAME=one-auth-smtp

echo "
    docker pull $DOCKER_REGISTRY/$API_IMAGE
    docker rm -f -v $API_NAME
    docker rm -f -v $POSTGRES_NAME

    docker run --name $POSTGRES_NAME \\
        -v ~/feedback_one_auth_data:/var/lib/postgresql/data \\
        -e POSTGRES_DB=$POSTGRES_DATABASE \\
        -e POSTGRES_USER=$POSTGRES_USER \\
        -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \\
        -d postgres:9.6

    docker rm -f $SMTP_NAME
    docker run --name $SMTP_NAME -d namshi/smtp

    docker run --name $API_NAME \\
        -v ~/feedback_one_auth_images:/app/statics/images \\
        --link $POSTGRES_NAME:postgres \\
        --link $SMTP_NAME:smtp \\
        -e ONE_AUTH_ENV=production \\
        -e DB_URL=$POSTGRES_URL \\
        -e DB_USER_NAME=$POSTGRES_USER \\
        -e DB_PASSWORD=$POSTGRES_PASSWORD \\
        -p 8000:8000 -p 5001:5000 \\
        -d $DOCKER_REGISTRY/$API_IMAGE
" | ssh ${user}@${host}
