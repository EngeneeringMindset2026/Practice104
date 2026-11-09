# Лабораторная работа 104. Docker for Beginners

Студент: Линберг Денис Алексеевич, РИЗМ-161207

## Цель работы

Познакомиться с Docker и базовыми командами Linux по тренингу <https://training.play-with-docker.com/beginner-linux/>. Выполнено локально в Docker Desktop (Windows 11, Git Bash).

## Файлы

- `linux_tweet_app/`: приложение из тренинга (`Dockerfile`, `index.html`, `index-new.html`, `linux.png`)
- `env.sh`: порты, читает `.env` (логин и токен Docker Hub, образец `.env.example`)
- `task1_run_containers.sh`: Alpine, Ubuntu, MySQL
- `task2_build_image.sh`: сборка `linux_tweet_app:1.0` и запуск сайта
- `task3_modify_site.sh`: bind mount, образ `2.0`, две версии одновременно
- `task4_push.sh`: публикация на Docker Hub
- `cleanup.sh`: удаление контейнеров работы

## Запуск

```bash
cp .env.example .env       # вписать DOCKER_TOKEN
./task1_run_containers.sh
./task2_build_image.sh
./task3_modify_site.sh      # если 8080 занят: OLD_WEB_PORT=8081 ./task3_modify_site.sh
./task4_push.sh
./cleanup.sh
```

## Что сделано

- Запущены контейнеры Alpine (одна команда), Ubuntu (`ps aux`, `/etc/issue`), MySQL в фоне (`logs`, `top`, `exec`).
- Собран образ сайта на `nginx:latest`, версия 1.0.
- Через bind mount сайт изменён без пересборки; собрана версия 2.0, обе версии запущены на разных портах.
- Образы 1.0 и 2.0 опубликованы на Docker Hub.
- Интерактивные команды тренинга (`-it`) заменены на `bash -c` / `sh -c`, чтобы скрипты шли без терминала.

## Выводы

- Контейнер стартует за доли секунды и видит только свои процессы и файлы.
- Образ после сборки не меняется: для нового сайта нужна новая версия образа.
- Bind mount подходит для файлов, которые меняются во время работы.
- С тегами можно держать несколько версий одновременно, с Docker Hub образ скачивается на любую машину.
