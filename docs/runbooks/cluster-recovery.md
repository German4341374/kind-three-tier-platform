# Local Cluster Recovery

The cluster is disposable. Preserve no important data in it.

1. Capture diagnostics with `kubectl get all -A` and `kubectl get events -A`.
2. Run `make down`. If the API server is unavailable, `kind delete cluster --name task-platform` remains valid.
3. Confirm Docker has enough CPU, memory, and disk. Remove only unused local images or volumes you own.
4. Run `make up` and then `make smoke`.

Deleting the cluster also deletes its PostgreSQL volume. This is intentional for the local demonstration.
