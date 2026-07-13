# ADR 0001: kind and Kustomize

**Status:** Accepted

kind provides disposable, upstream-conformant Kubernetes nodes as local containers and works on Linux or WSL2 with Docker. Kustomize keeps one auditable base and small development/production-style patches without introducing template syntax. The trade-off is that kind is not a production control plane and Kustomize cannot express every packaging workflow that Helm supports.
