#!/usr/bin/env bash
set -e

for item in $(docker service ls -q --filter label=com.docker.stack.namespace=${1} --format '{{ .Name }}'); do
  image=$(docker service inspect ${item} | jq -r .[].Spec.TaskTemplate.ContainerSpec.Image | sed 's/@.*$//')
  echo ${item} ${image}
done
