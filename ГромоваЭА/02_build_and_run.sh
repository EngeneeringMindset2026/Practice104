#!/usr/bin/env bash
# Task 2: сборка и запуск linux_tweet_app:1.0
set -euo pipefail

cd "$(dirname "$0")"

DOCKERID="${DOCKERID:-gromikkkk}"
echo "DOCKERID=$DOCKERID"

docker image build --tag "$DOCKERID/linux_tweet_app:1.0" .

docker rm --force linux_tweet_app 2>/dev/null || true
docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  "$DOCKERID/linux_tweet_app:1.0"

echo "Сайт: http://localhost"
echo "Остановить: docker container rm --force linux_tweet_app"
