# Interview Questions and Answers

## 1. Why use kind?

kind runs upstream Kubernetes nodes as Docker containers, making a disposable multi-node cluster practical for local development and CI without a cloud account.

## 2. Why separate application and data namespaces?

Namespaces create policy and ownership boundaries. They allow the database to accept traffic only from explicitly selected API pods in the application namespace.

## 3. What does a Deployment provide?

A Deployment declares the desired pod replicas and update strategy, creates ReplicaSets, replaces failed pods, and records rollout revisions.

## 4. Why use a StatefulSet for PostgreSQL?

PostgreSQL needs stable storage identity. A StatefulSet associates an ordered pod identity with a persistent volume claim more clearly than a stateless Deployment.

## 5. What is a Kubernetes Service?

A Service provides stable discovery and virtual networking for a changing set of pods selected by labels.

## 6. What does Ingress do?

Ingress describes HTTP routing. The NGINX Ingress controller implements it, sending `/api` to FastAPI and `/` to the frontend.

## 7. How do startup, readiness, and liveness probes differ?

Startup protects slow initialization, readiness controls Service endpoints, and liveness restarts a process that is no longer healthy.

## 8. Why does API readiness check PostgreSQL?

An API pod unable to serve task requests should not receive traffic. Readiness removes it from Service endpoints until its dependency works.

## 9. Why must liveness not check PostgreSQL?

A database outage should not restart every API pod. That would add load and turn a dependency failure into a restart storm.

## 10. What are resource requests?

Requests tell the scheduler how much capacity a pod needs and form the baseline for percentage-based HPA CPU calculations.

## 11. What are resource limits?

Limits cap consumption. CPU is throttled above its limit; exceeding a memory limit can cause an OOM kill.

## 12. How does the HPA work here?

metrics-server supplies CPU usage. HPA adjusts frontend and API replica counts to target 70 percent of requested CPU within overlay-specific bounds.

## 13. What does a PDB guarantee?

A PDB limits simultaneous voluntary disruption such as node drain. It does not prevent crashes, node loss, or application bugs.

## 14. How is a zero-unavailable rollout attempted?

The Deployment uses `maxUnavailable: 0` and `maxSurge: 1`, so a new pod must become ready before an old healthy pod is removed.

## 15. How does rollback work?

Deployment revision history retains earlier ReplicaSets. `kubectl rollout undo` changes the pod template back to a selected prior revision.

## 16. Why use Kustomize?

Kustomize produces normal Kubernetes YAML from a shared base plus targeted environment patches, avoiding copied manifests and template-language complexity.

## 17. What changes in the production-style overlay?

It uses three replicas, stricter PDBs, larger API requests and limits, higher HPA bounds, production configuration, and versioned image tags.

## 18. Are Kubernetes Secrets encrypted?

Not necessarily. Secret data is base64 encoded and can be stored unencrypted in etcd unless the cluster enables encryption. This project uses disposable placeholders only.

## 19. How is least privilege applied?

Workloads receive dedicated ServiceAccounts with token mounting disabled, non-root identities, no added Linux capabilities, and narrowly allowed network paths.

## 20. Why install Calico?

The demo needs a CNI that enforces Kubernetes NetworkPolicy. Calico makes the default-deny and cross-namespace allow lists functional in kind.

## 21. What traffic is allowed?

Ingress NGINX can reach frontend and API ports, API can reach PostgreSQL, and workloads can reach cluster DNS. Other application/data namespace traffic is denied.

## 22. How does persistent storage behave locally?

The PostgreSQL claim binds through kind's storage provisioner and survives pod replacement, but deleting the kind cluster removes the node and its data.

## 23. What does kubeconform validate?

It checks rendered Kubernetes resources against versioned schemas, catching invalid fields and types before a cluster deployment.

## 24. How do kube-linter and Trivy differ?

kube-linter checks Kubernetes workload practices. Trivy scans IaC and repository configuration for security problems. They cover different classes of mistakes.

## 25. How would you debug Pending?

Inspect pod events, node capacity, resource requests, taints, selectors, PVC binding, quotas, and Pod Security admissions.

## 26. How would you debug a Service with no endpoints?

Compare the Service selector with pod labels, verify readiness, inspect EndpointSlices, and then check ports and NetworkPolicies.

## 27. Is this production Kubernetes?

No. It demonstrates production-style workload controls on a disposable local control plane. It lacks managed control-plane HA, durable storage, backups, TLS, and organizational operations.

## 28. Why run kind in CI?

Schema validation cannot prove runtime behavior. A real cluster catches image startup, DNS, policy, probe, migration, Ingress, smoke-test, and rollback integration failures.
