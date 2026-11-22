#!/usr/bin/env bash
# Task 3: bind mount + версии 1.0 и 2.0
set -euo pipefail

cd "$(dirname "$0")"

DOCKERID="${DOCKERID:-gromikkkk}"
echo "DOCKERID=$DOCKERID"

docker rm --force linux_tweet_app old_linux_tweet_app 2>/dev/null || true
cp index-original.html index.html

echo "=== Bind mount ==="
docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  --mount type=bind,source="$(pwd)",target=/usr/share/nginx/html \
  "$DOCKERID/linux_tweet_app:1.0"

echo "Сайт: http://localhost"
cp index-new.html index.html
echo "index.html заменён на новую версию — обнови страницу в браузере."

read -r -p "Enter для сборки 2.0..."

docker rm --force linux_tweet_app

echo "=== Сборка 2.0 ==="
docker image build --tag "$DOCKERID/linux_tweet_app:2.0" .

docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  "$DOCKERID/linux_tweet_app:2.0"

docker container run \
  --detach \
  --publish 8080:80 \
  --name old_linux_tweet_app \
  "$DOCKERID/linux_tweet_app:1.0"

docker image ls
echo "2.0: http://localhost"
echo "1.0: http://localhost:8080"
