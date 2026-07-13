#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
action="${1:-create}"

case "${action}" in
  create)
    docker info >/dev/null
    if kind get clusters | grep -qx task-platform; then
      echo "kind cluster task-platform already exists."
    else
      kind create cluster --config "${root}/kind/cluster.yaml"
    fi
    "${root}/scripts/install-addons.sh"
    "${root}/scripts/build-images.sh" dev
    "${root}/scripts/deploy.sh" development
    ;;
  delete)
    kind delete cluster --name task-platform
    ;;
  *) echo "Usage: $0 create|delete" >&2; exit 1 ;;
esac
