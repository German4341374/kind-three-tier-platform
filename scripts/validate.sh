#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "${root}/build"
yamllint -c "${root}/.yamllint.yml" "${root}/kubernetes" "${root}/kind" "${root}/.github"
for overlay in development production; do
  kustomize build "${root}/kubernetes/overlays/${overlay}" > "${root}/build/${overlay}.yaml"
  kubeconform -strict -summary -kubernetes-version 1.36.0 "${root}/build/${overlay}.yaml"
  kube-linter lint --config "${root}/.kube-linter.yaml" "${root}/build/${overlay}.yaml"
done
trivy config --exit-code 1 --severity HIGH,CRITICAL "${root}/api"
trivy config --exit-code 1 --severity HIGH,CRITICAL "${root}/frontend"
trivy config --exit-code 1 --severity HIGH,CRITICAL "${root}/build"
