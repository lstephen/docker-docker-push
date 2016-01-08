#!/usr/bin/env bash

set -e

sha=$(git rev-parse --short HEAD)
name=$DOCKER_PUSH_NAME

function build {
  docker build -t $name:$sha
}

for target in $@
do
  echo "** Execute $target"
  $target
done
