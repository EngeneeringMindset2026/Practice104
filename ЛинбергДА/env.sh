#!/usr/bin/env bash
# Общие настройки для всех скриптов лабораторной.
# DOCKERID: логин на Docker Hub (можно переопределить: DOCKERID=myid ./task2_build_image.sh)
# Логин и токен Docker Hub берутся из .env (образец: .env.example)
ENV_FILE="$(dirname "${BASH_SOURCE[0]}")/.env"
if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
fi
export DOCKERID="${DOCKERID:-disadisa111}"
# Порт для сайта на хосте (в тренинге используется 80)
export WEB_PORT="${WEB_PORT:-80}"
export OLD_WEB_PORT="${OLD_WEB_PORT:-8080}"

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/linux_tweet_app" && pwd)"
# В Git Bash на Windows docker ожидает путь вида D:/..., а не /d/...
APP_DIR_HOST="$(cd "$APP_DIR" && (pwd -W 2>/dev/null || pwd))"
export APP_DIR APP_DIR_HOST
