#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
overlay="${1:-development}"
[[ "${overlay}" == "development" || "${overlay}" == "production" ]] || { echo "Overlay must be development or production." >&2; exit 1; }
kubectl apply -k "${root}/kubernetes/overlays/${overlay}"
kubectl rollout status statefulset/postgres -n task-data --timeout=240s
kubectl rollout status deployment/api -n task-app --timeout=240s
kubectl rollout status deployment/frontend -n task-app --timeout=240s
