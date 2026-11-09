#!/usr/bin/env bash
# Удаление контейнеров, созданных в ходе работы.
cd "$(dirname "$0")" && source ./env.sh
docker container rm --force mydb linux_tweet_app old_linux_tweet_app 2>/dev/null
