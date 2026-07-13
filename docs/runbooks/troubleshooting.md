# Kubernetes Troubleshooting Runbook

Start every incident by recording the context and recent events:

```bash
kubectl config current-context
kubectl get pods -A -o wide
kubectl get events -A --sort-by=.lastTimestamp
```

## CrashLoopBackOff

1. Run `kubectl describe pod POD -n NAMESPACE` and inspect exit codes and probe events.
2. Read current and previous logs: `kubectl logs POD -n NAMESPACE --all-containers` and `kubectl logs POD -n NAMESPACE --previous`.
3. Check ConfigMap/Secret names, command arguments, file permissions, memory limits, and database connectivity.
4. Fix the declarative source and redeploy. Do not patch a pod because the controller will replace it.

## Pending pods

1. Inspect scheduling events with `kubectl describe pod POD -n NAMESPACE`.
2. Compare requests with `kubectl describe nodes`; inspect PVCs using `kubectl get pvc -A`.
3. Check node selectors, taints, storage class availability, quota, and Pod Security rejection.
4. Reduce only unjustified requests or add appropriate capacity. Do not remove limits blindly.

## Failed probes

1. Read probe events and test from inside the pod: `kubectl exec POD -n NAMESPACE -- wget -qO- URL`.
2. Confirm the probe port, path, timeout, initial delay, and application bind address.
3. For API readiness, inspect PostgreSQL and NetworkPolicy before increasing thresholds.
4. Keep liveness independent of downstream services to avoid cascading restarts.

## Unavailable Service or Ingress

1. Compare Service selectors with pod labels and check endpoints: `kubectl get svc,endpoints,endpointslices -n task-app`.
2. Test ClusterIP DNS from an allowed pod and inspect default-deny NetworkPolicies.
3. Inspect `kubectl describe ingress -n task-app` and ingress controller logs.
4. Verify the required `Host: task.localhost` header and local port `8080`.

## Rollback

Use `kubectl rollout history deployment/NAME -n task-app`, inspect the target revision, then run `kubectl rollout undo deployment/NAME -n task-app --to-revision=N`. Wait for rollout status and repeat the smoke test. `scripts/rollback-demo.sh` performs a controlled disposable example.
