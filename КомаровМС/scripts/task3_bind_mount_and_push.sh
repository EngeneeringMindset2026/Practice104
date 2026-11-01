#!/usr/bin/env bash
# Task 3: Modify a running website
#  - запуск с bind mount и изменение сайта "на лету"
#  - сборка новой версии образа 2.0
#  - одновременный запуск версий 1.0 (порт 8080) и 2.0 (порт 80)
#  - публикация образов на Docker Hub
# Перед запуском: export DOCKERID=<ваш Docker ID>; должен быть выполнен task2 (образ 1.0)

source "$(dirname "$0")/common.sh"
cd "$APP_DIR"

pause() { read -r -p "$1 Нажмите Enter для продолжения..."; }

echo "=== 3.1 Запуск с bind mount (каталог хоста -> /usr/share/nginx/html) ==="
run docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  --mount type=bind,source="$(host_path .)",target=/usr/share/nginx/html \
  "$IMAGE:1.0"
check_site 80
pause "Сайт исходный (синий фон)."

echo "=== 3.2 Изменение сайта без пересборки образа ==="
run cp index-new.html index.html
check_site 80
pause "Обновите страницу - фон стал оранжевым."

echo "=== 3.3 Образ при этом не изменился ==="
run docker rm --force linux_tweet_app
run docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  "$IMAGE:1.0"
check_site 80
pause "Без bind mount снова исходная (синяя) версия."
run docker rm --force linux_tweet_app

echo "=== 3.4 Новая версия образа 2.0 (index.html уже изменён) ==="
run docker image build --tag "$IMAGE:2.0" .
run docker image ls

echo "=== 3.5 Версии 2.0 и 1.0 одновременно на разных портах ==="
run docker container run \
  --detach \
  --publish 80:80 \
  --name linux_tweet_app \
  "$IMAGE:2.0"
run docker container run \
  --detach \
  --publish 8080:80 \
  --name old_linux_tweet_app \
  "$IMAGE:1.0"
check_site 80
check_site 8080
pause "Порт 80 - версия 2.0 (оранжевая), порт 8080 - версия 1.0 (синяя)."

echo "=== 3.6 Публикация образов на Docker Hub ==="
run docker image ls -f reference="$DOCKERID/*"
run docker login --username "$DOCKERID"
run docker image push "$IMAGE:1.0"
# У версии 2.0 большинство слоёв совпадает с 1.0 -> "Layer already exists"
run docker image push "$IMAGE:2.0"

echo
echo "Образы опубликованы: https://hub.docker.com/r/$DOCKERID/linux_tweet_app"
