#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/tool-versions.sh"
root="$(cd "$(dirname "$0")/.." && pwd)"
bin="${root}/.tools/bin"
mkdir -p "${bin}"
arch="$(uname -m)"
case "${arch}" in
  x86_64) goarch="amd64"; trivy_arch="64bit"; linter_asset="kube-linter-linux" ;;
  aarch64|arm64) goarch="arm64"; trivy_arch="ARM64"; linter_asset="kube-linter-linux_arm64" ;;
  *) echo "Unsupported architecture: ${arch}" >&2; exit 1 ;;
esac
curl -fsSL "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-${goarch}" -o "${bin}/kind"
curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${goarch}/kubectl" -o "${bin}/kubectl"
curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${goarch}.tar.gz" | tar -xz -C "${bin}"
curl -fsSL "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-${goarch}.tar.gz" | tar -xz -C "${bin}"
curl -fsSL "https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINTER_VERSION}/${linter_asset}" -o "${bin}/kube-linter"
curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-${trivy_arch}.tar.gz" | tar -xz -C "${bin}" trivy
chmod +x "${bin}"/*
printf 'Tools installed in %s\nAdd it to PATH with: export PATH="%s:$PATH"\n' "${bin}" "${bin}"
