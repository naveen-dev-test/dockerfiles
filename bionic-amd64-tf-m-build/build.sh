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

cp -a ../setup-sshd .

# Copy armclang toolchains required for the build (previously fetched
# from s3://trustedfirmware-private/armclang/ by build harness).
cp ../ARMCompiler6.21_standalone_linux-x86_64.tar.gz .

image=trustedfirmware/ci-${ARCHITECTURE}-${PROJECT}-ubuntu:${DISTRIBUTION}${DOCKER_SUFFIX}
docker build --pull --tag=$image .
echo $image > .docker-tag
