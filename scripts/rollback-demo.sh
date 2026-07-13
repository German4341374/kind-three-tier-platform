#!/usr/bin/env bash
set -Eeuo pipefail
namespace="task-app"
deployment="frontend"

kubectl rollout status "deployment/${deployment}" -n "${namespace}" --timeout=120s
kubectl set image "deployment/${deployment}" frontend=kind.local/task-frontend:broken-demo-tag -n "${namespace}"
if kubectl rollout status "deployment/${deployment}" -n "${namespace}" --timeout=20s; then
  echo "Expected the deliberately broken rollout to fail." >&2
  exit 1
fi
kubectl rollout undo "deployment/${deployment}" -n "${namespace}"
kubectl rollout status "deployment/${deployment}" -n "${namespace}" --timeout=180s
echo "Controlled rollback completed successfully."
