#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
tag="${1:-dev}"
docker build --pull -t "kind.local/task-api:${tag}" "${root}/api"
docker build --pull -t "kind.local/task-frontend:${tag}" "${root}/frontend"
kind load docker-image --name task-platform "kind.local/task-api:${tag}" "kind.local/task-frontend:${tag}"
