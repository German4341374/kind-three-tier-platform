# Repository Guidelines

- Keep source code, comments, manifests, commits, and documentation in English.
- Never commit real credentials, kubeconfig files, generated manifests, or local cluster state.
- Preserve non-root containers, restricted Pod Security, probes, resource controls, and default-deny policies.
- Make shared changes in `kubernetes/base` and environment differences in overlays.
- Run static validation and unit tests before committing; run kind smoke tests when Docker is available.
- Do not weaken a security check without documenting the threat and trade-off.
