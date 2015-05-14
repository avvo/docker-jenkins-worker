#!/bin/bash
set -e

VERSION=$1

if [ "x$VERSION" == "x" ];
then
  VERSION="jenkins-worker:test_$BUILD_NUMBER"
fi

if [ "x$IMAGE_NAME" == "x" ]
then
  IMAGE_NAME=$VERSION
fi

docker tag -f $IMAGE_NAME registry.docker.prod.avvo.com/jenkins-worker:latest
docker push registry.docker.prod.avvo.com/jenkins-worker:latest