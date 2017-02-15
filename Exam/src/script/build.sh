#!/usr/bin/env bash

DOCKER_REGISTRY="tw.chinacloudapp.cn:5000"

docker build -t one-auth:$GO_PIPELINE_COUNTER .
docker tag one-auth:$GO_PIPELINE_COUNTER $DOCKER_REGISTRY/one-auth:$GO_PIPELINE_COUNTER
docker push $DOCKER_REGISTRY/one-auth:$GO_PIPELINE_COUNTER