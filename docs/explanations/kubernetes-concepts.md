# Kubernetes Concepts Used Here

## Deployments and rollouts

Deployments maintain frontend and API replica sets. Their rolling-update strategy creates one replacement before removing an old pod (`maxSurge: 1`, `maxUnavailable: 0`). Revision history enables `kubectl rollout undo`.

## Services and Ingress

ClusterIP Services give stable virtual addresses while pods change. The API and frontend Services select pods by labels. The NGINX Ingress controller accepts host traffic and routes `/api` to the API and `/` to the frontend. PostgreSQL uses a headless Service because its StatefulSet needs stable DNS.

## Probes

Startup probes give slow initialization time without premature restarts. Readiness controls whether a pod receives Service traffic. Liveness detects a stuck process and asks the kubelet to restart it. API readiness checks PostgreSQL, while API liveness deliberately does not depend on the database.

## Requests, limits, and autoscaling

Requests influence scheduling and provide the denominator for CPU utilization. Limits cap container consumption. HPA uses metrics-server to scale frontend and API replicas around 70 percent requested CPU. Stabilization reduces scale-down oscillation.

## Availability

PDBs limit voluntary disruption, but do not prevent crashes. Multiple replicas and rolling-update settings preserve service during changes. The production-style overlay uses three replicas and allows at most one voluntary disruption.

## Storage and secrets

The PostgreSQL StatefulSet receives a persistent volume claim from kind's default storage class. Placeholder Secrets demonstrate wiring only; Kubernetes Secrets are base64-encoded objects, not an encrypted secret-management solution.
