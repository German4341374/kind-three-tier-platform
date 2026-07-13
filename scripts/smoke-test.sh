#!/usr/bin/env bash
set -Eeuo pipefail
base_url="${BASE_URL:-http://127.0.0.1:8080}"
host="${INGRESS_HOST:-task.localhost}"

retry() {
  local attempts=30
  until "$@"; do
    attempts=$((attempts - 1))
    [[ ${attempts} -gt 0 ]] || return 1
    sleep 2
  done
}

retry curl --fail --silent --show-error -H "Host: ${host}" "${base_url}/healthz" >/dev/null
retry curl --fail --silent --show-error -H "Host: ${host}" "${base_url}/api/tasks" >/dev/null
curl --fail --silent --show-error -H "Host: ${host}" -H "Content-Type: application/json" \
  -d '{"title":"Smoke test task"}' "${base_url}/api/tasks" >/dev/null
curl --fail --silent --show-error -H "Host: ${host}" "${base_url}/api/tasks" | grep -q "Smoke test task"
kubectl get pods -n task-app
kubectl get pods -n task-data
echo "Smoke test passed."
