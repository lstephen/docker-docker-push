#!/usr/bin/env bash

set -e

sha=$(git rev-parse --short HEAD)
name=$DOCKER_PUSH_NAME

function set_version {
  version=$(git log --oneline --first-parent master | wc -l | xargs)

  branch=$(git branch | grep '*')

  if [[ ! $branch =~ master$ ]]
  then
    branch_count=$[$(git log --oneline --first-parent | wc -l | xargs) - $version]
    version="$version.dev$branch_count"
  fi
}

function setup_ssh {
  if [[ -d "/ssh" ]]
  then
    cp /ssh/* /root/.ssh
    chmod -R 600 /root/.ssh
  fi
}

function build {
  echo "Building $name:$sha..."
  docker build -t $name:$sha .
}

function release {
  echo "Docker tagging $name:$version..."
  docker tag -f $name:$sha $name:$version
  docker tag -f $name:$sha $name:latest

  echo "Pushing $name:$version..."
  docker login -u "$DOCKER_PUSH_USERNAME" -p "$DOCKER_PUSH_PASSWORD" -e "$DOCKER_PUSH_EMAIL"

  docker push $name:$version
  docker push $name:latest

  echo "Git tagging $name:$version..."
  git_tag="v$version"
  git tag $git_tag
  git push origin $git_tag
}

set_version
setup_ssh

for target in $@
do
  echo "** Execute $target"
  $target
done
