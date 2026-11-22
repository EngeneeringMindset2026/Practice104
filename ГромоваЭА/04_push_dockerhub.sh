#!/usr/bin/env bash
# Публикация образов в Docker Hub
set -euo pipefail

DOCKERID="${DOCKERID:-gromikkkk}"
echo "DOCKERID=$DOCKERID"

docker login
docker image ls -f "reference=$DOCKERID/*"
docker image push "$DOCKERID/linux_tweet_app:1.0"
docker image push "$DOCKERID/linux_tweet_app:2.0"

echo "Проверка: https://hub.docker.com/r/$DOCKERID/linux_tweet_app"
