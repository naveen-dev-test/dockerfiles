#!/bin/sh

set -e

export LANG=C

image=trustedfirmware/ci-node-tf-a-alpine:alpine10${DOCKER_SUFFIX}
docker build --pull --tag=$image .
echo $image > .docker-tag
