#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f *.list *.key
}

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')
PROJECT=$(basename ${PWD} | cut -f3 -d '-')-$(basename ${PWD} | cut -f4 -d '-')

image=trustedfirmware/ci-${ARCHITECTURE}-${PROJECT}-ubuntu:${DISTRIBUTION}${DOCKER_SUFFIX}
docker build --pull --tag=$image .
echo $image > .docker-tag
