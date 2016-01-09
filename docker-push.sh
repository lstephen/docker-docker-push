#!/usr/bin/env bash

set -e

sha=$(git rev-parse --short HEAD)
name=$DOCKER_PUSH_NAME

function set_version {
  if [[ -f "VERSION" ]]
  then
    version=$(cat VERSION)
  fi
}

function setup_ssh {
  mkdir -p /root/.ssh

  if [[ -d "/ssh" ]]
  then
    cp /ssh/* /root/.ssh
    chmod -R 600 /root/.ssh
  fi

  printf "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
}

function build {
  echo "Building $name:$sha..."
  docker build -t $name:$sha .
}

function release {
  docker login -u "$DOCKER_PUSH_USERNAME" -p "$DOCKER_PUSH_PASSWORD" -e "$DOCKER_PUSH_EMAIL"

  echo "Pushing $name:latest..."
  docker tag -f $name:$sha $name:latest
  docker push $name:latest

  if [[ -n "$version" ]]
  then
    echo "Pushing $name:$version..."
    docker tag -f $name:$sha $name:$version
    docker push $name:$version

    echo "Git tagging $name:$version..."
    git_tag="v$version"
    git tag $git_tag
    git push origin $git_tag
  fi
}

set_version
setup_ssh

for target in $@
do
  echo "** Execute $target"
  $target
done
