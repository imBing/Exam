#! /bin/bash

output=`docker logs one-auth-dev 2>&1 | \
  grep "Use the following code to finish your registration process:" | \
  awk -F"Use the following code to finish your registration process:" '{print $2}' | \
  sed s/\\\.//g | \
  sed s/\'//g`

echo ${output:0:7}
