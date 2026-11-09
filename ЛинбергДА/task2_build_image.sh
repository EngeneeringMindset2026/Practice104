#!/usr/bin/env bash
# Task 2. Сборка образа сайта linux_tweet_app и запуск контейнера.
set -euo pipefail
cd "$(dirname "$0")" && source ./env.sh
set -x

cat "$APP_DIR/Dockerfile"
docker image build --tag "$DOCKERID/linux_tweet_app:1.0" "$APP_DIR"

docker container run \
  --detach \
  --publish "$WEB_PORT:80" \
  --name linux_tweet_app \
  "$DOCKERID/linux_tweet_app:1.0"
sleep 2
curl -s "http://localhost:$WEB_PORT" | grep -o 'linear-gradient(to top, #[0-9a-f]*' || true

docker container rm --force linux_tweet_app
