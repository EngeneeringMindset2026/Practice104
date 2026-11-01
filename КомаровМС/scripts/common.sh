#!/usr/bin/env bash
# Общие настройки для всех скриптов лабораторной.
# Подключается командой: source "$(dirname "$0")/common.sh"

set -euo pipefail

# Git Bash / MSYS2 на Windows автоматически переписывает аргументы вида /usr/share/...
# в пути Windows - для docker это ломает --mount. Отключаем (на Linux переменная ни на что не влияет).
export MSYS_NO_PATHCONV=1

# Путь к каталогу в формате, понятном Docker: на Windows (MSYS) - C:/..., на Linux - обычный
host_path() { (cd "$1" && (pwd -W 2>/dev/null || pwd)); }

# Каталог с приложением (Dockerfile, index.html, linux.png)
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../app" && pwd)"

# Docker ID (логин на Docker Hub). Задаётся заранее: export DOCKERID=<ваш_логин>
if [ -z "${DOCKERID:-}" ]; then
  echo "Ошибка: не задан DOCKERID. Выполните: export DOCKERID=<ваш Docker ID>" >&2
  exit 1
fi

IMAGE="$DOCKERID/linux_tweet_app"

# Печать команды перед выполнением - чтобы в выводе (и на скриншотах) было видно, что запускается
run() {
  echo
  echo "\$ $*"
  "$@"
}

# Ожидание, пока сайт на заданном порту начнёт отвечать, и вывод заголовка страницы
check_site() {
  local port="$1"
  for _ in $(seq 1 20); do
    if curl -fs "http://localhost:$port" >/dev/null; then
      echo "Сайт на порту $port отвечает. Фон страницы:"
      curl -fs "http://localhost:$port" | grep -o 'linear-gradient(to top, #[0-9a-f]*' | head -1
      return 0
    fi
    sleep 1
  done
  echo "Сайт на порту $port не ответил" >&2
  return 1
}
