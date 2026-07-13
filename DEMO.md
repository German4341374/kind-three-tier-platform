# Five-Minute Employer Demonstration

Prepare the cluster before the call with `make up && make smoke`. Keep the application, README diagram, and two terminals visible.

## 0:00-0:45 — Architecture

Show the Mermaid diagram. Explain that kind runs three Kubernetes nodes in Docker, Calico enforces policy, NGINX routes browser traffic, FastAPI handles tasks, and PostgreSQL stores them on a persistent volume across pod recreation.

## 0:45-1:30 — Declarative configuration

Open `kubernetes/base/api.yaml` and point out rolling updates, non-root security context, startup/readiness/liveness probes, requests/limits, and the migration init container. Open both Kustomize overlays and show that environment differences are small patches over one base.

## 1:30-2:15 — Live health

```bash
kubectl get nodes
kubectl get pods,svc,ingress,hpa,pdb -n task-app
kubectl get pods,pvc -n task-data
make smoke
```

Create a task in the browser at `http://task.localhost:8080` and refresh to show persistence.

## 2:15-3:00 — Network and security

Show `kubernetes/base/network-policies.yaml`: all traffic starts denied, Ingress can reach frontend/API, and only API pods can reach PostgreSQL. Mention restricted Pod Security, no automatic API tokens, non-root users, dropped capabilities, schema validation, kube-linter, and Trivy.

## 3:00-4:15 — Controlled failure and rollback

```bash
make rollback
kubectl rollout history deployment/frontend -n task-app
make smoke
```

Explain that the script uses a nonexistent image, observes the failed rollout, and undoes it. `maxUnavailable: 0` preserves the old working replica.

## 4:15-5:00 — Operations and CI

Show the troubleshooting runbook and GitHub Actions. Explain that CI performs static validation, then creates a real kind cluster, builds images, deploys, smoke-tests, rolls back, collects diagnostics, and deletes the cluster.

Finish by running `make down` after the interview. State clearly that this deletes all local PostgreSQL data.
