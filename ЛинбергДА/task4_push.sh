#!/usr/bin/env bash
# Task 4. Публикация образов на Docker Hub (логин и токен в .env).
set -euo pipefail
cd "$(dirname "$0")" && source ./env.sh

docker image ls -f "reference=$DOCKERID/*"
if [ -n "${DOCKER_TOKEN:-}" ]; then
  # Токен передаётся через stdin, чтобы не попасть в историю и вывод set -x
  printf '%s' "$DOCKER_TOKEN" | docker login -u "$DOCKERID" --password-stdin
else
  docker login -u "$DOCKERID"
fi

set -x
docker image push "$DOCKERID/linux_tweet_app:1.0"
docker image push "$DOCKERID/linux_tweet_app:2.0"
