#!/usr/bin/env bash
# Task 2: Package and run a custom app using Docker
# Сборка образа веб-сайта из Dockerfile и запуск контейнера на порту 80.
# Перед запуском: export DOCKERID=<ваш Docker ID>

source "$(dirname "$0")/common.sh"
cd "$APP_DIR"

run cat Dockerfile

# Сборка образа версии 1.0; точка в конце - контекст сборки (текущий каталог)
run docker image build --tag "$IMAGE:1.0" .

# Запуск контейнера: порт 80 хоста -> порт 80 контейнера
run docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  "$IMAGE:1.0"

check_site 80
echo "Откройте http://localhost (или кнопку порта 80 в Play with Docker) и сделайте скриншот."
read -r -p "Нажмите Enter, чтобы остановить и удалить контейнер..."

# --force останавливает и удаляет работающий контейнер
run docker container rm --force linux_tweet_app
