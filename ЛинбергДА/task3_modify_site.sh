#!/usr/bin/env bash
# Task 3. Изменение работающего сайта через bind mount и сборка версии 2.0.
set -euo pipefail
cd "$(dirname "$0")" && source ./env.sh
set -x

# 3.1. Запуск с bind mount: каталог приложения на хосте подменяет html в контейнере
docker container run \
  --detach \
  --publish "$WEB_PORT:80" \
  --name linux_tweet_app \
  --mount "type=bind,source=$APP_DIR_HOST,target=/usr/share/nginx/html" \
  "$DOCKERID/linux_tweet_app:1.0"

# 3.2. Меняем index.html на хосте, сайт в контейнере меняется сразу
cp "$APP_DIR/index.html" "$APP_DIR/index.html.bak"
cp "$APP_DIR/index-new.html" "$APP_DIR/index.html"
sleep 1
curl -s "http://localhost:$WEB_PORT" | grep -o 'linear-gradient(to top, #[0-9a-f]*' || true

# 3.3. Образ при этом не изменился: без bind mount снова старая версия
docker rm --force linux_tweet_app
docker container run --detach --publish "$WEB_PORT:80" --name linux_tweet_app \
  "$DOCKERID/linux_tweet_app:1.0"
sleep 2
curl -s "http://localhost:$WEB_PORT" | grep -o 'linear-gradient(to top, #[0-9a-f]*' || true
docker rm --force linux_tweet_app

# 3.4. Новая версия образа с изменённым index.html
docker image build --tag "$DOCKERID/linux_tweet_app:2.0" "$APP_DIR"
docker image ls

# 3.5. Обе версии одновременно: 2.0 на WEB_PORT, 1.0 на OLD_WEB_PORT
docker container run --detach --publish "$WEB_PORT:80" --name linux_tweet_app \
  "$DOCKERID/linux_tweet_app:2.0"
docker container run --detach --publish "$OLD_WEB_PORT:80" --name old_linux_tweet_app \
  "$DOCKERID/linux_tweet_app:1.0"
sleep 2
curl -s "http://localhost:$WEB_PORT" | grep -o 'linear-gradient(to top, #[0-9a-f]*' || true
curl -s "http://localhost:$OLD_WEB_PORT" | grep -o 'linear-gradient(to top, #[0-9a-f]*' || true

# Синий градиент (#127ab1) = версия 1.0, оранжевый (#f25a02) = новая версия

# Возвращаем исходный index.html, чтобы скрипты можно было запускать повторно
mv "$APP_DIR/index.html.bak" "$APP_DIR/index.html"
