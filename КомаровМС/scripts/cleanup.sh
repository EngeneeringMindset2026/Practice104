#!/usr/bin/env bash
# Удаление всех контейнеров лабораторной и возврат index.html к исходной версии.

set -uo pipefail

APP_DIR="$(cd "$(dirname "$0")/../app" && pwd)"

docker container rm --force linux_tweet_app old_linux_tweet_app mydb 2>/dev/null
# Остановленные контейнеры Alpine из Task 1
docker container ls --all --quiet --filter ancestor=alpine | xargs -r docker container rm

cp "$APP_DIR/index-original.html" "$APP_DIR/index.html"
echo "Контейнеры удалены, index.html восстановлен."

# Образы удаляются вручную при необходимости:
#   docker image rm "$DOCKERID/linux_tweet_app:1.0" "$DOCKERID/linux_tweet_app:2.0"
