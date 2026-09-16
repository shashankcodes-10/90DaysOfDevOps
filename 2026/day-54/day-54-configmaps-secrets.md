# Day 54 – Kubernetes ConfigMaps and Secrets

## What are ConfigMaps and Secrets?

A **ConfigMap** stores non-sensitive configuration such as environment names, feature flags, ports, and application settings.

A **Secret** stores sensitive configuration such as database usernames, passwords, API tokens, and credentials. Kubernetes Secret values are base64-encoded by default, which is encoding and not encryption.

## ConfigMap from Literals

```bash
kubectl create configmap app-config \
  --from-literal=APP_ENV=production \
  --from-literal=APP_DEBUG=false \
  --from-literal=APP_PORT=8080

kubectl describe configmap app-config
kubectl get configmap app-config -o yaml
```

The three values are stored as plain text in the ConfigMap.

## ConfigMap from a File

The `default.conf` file contains an Nginx `/health` endpoint.

```bash
kubectl create configmap nginx-config \
  --from-file=default.conf=k8s/default.conf

kubectl get configmap nginx-config -o yaml
```

When mounted, the `default.conf` key becomes a file with the same name.

## Using ConfigMaps

`app-config-pod.yaml` uses `envFrom` and imports all ConfigMap keys as environment variables.

`nginx-config-pod.yaml` mounts the Nginx ConfigMap as a volume at `/etc/nginx/conf.d`.

Environment variables are useful for simple key-value configuration, while volume mounts are useful for complete configuration files.

## Secrets

```bash
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASSWORD='s3cureP@ssw0rd'

kubectl get secret db-credentials -o yaml

kubectl get secret db-credentials \
  -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
```

Base64 is **not encryption**. A user with sufficient cluster access can decode the value. Security comes from controls such as RBAC and, when configured, encryption at rest.

## Using Secrets in a Pod

`secret-pod.yaml` demonstrates two methods:

- `secretKeyRef` injects `DB_USER` as an environment variable.
- A read-only volume mounts the complete Secret at `/etc/db-credentials`.

Secret volume files contain the decoded plaintext value, not the base64 representation.

## Environment Variables vs Volume Mounts

| Method | ConfigMap/Secret update | Typical use |
|---|---|---|
| Environment variable | Does not update in an existing Pod | Simple application settings |
| Volume mount | Updates automatically after Kubernetes refreshes the mounted volume | Configuration files and credentials |

Environment variables are populated when the container starts. A running container will not automatically receive a changed environment variable.

Volume-mounted ConfigMaps and Secrets are periodically refreshed by Kubernetes, so applications that reread the mounted files can observe changes without restarting the Pod.

## ConfigMap Update Propagation

The `live-config` example mounts the ConfigMap as a volume and reads the file every five seconds.

Create it:

```bash
kubectl create configmap live-config --from-literal=message=hello
kubectl apply -f k8s/live-config-pod.yaml
```

Update it:

```bash
kubectl patch configmap live-config --type merge -p '{"data":{"message":"world"}}'
```

After Kubernetes refreshes the mounted volume, the file changes from `hello` to `world` without restarting the Pod.

## Complete Flow

```text
ConfigMap
├── app-config
│   └── Environment variables
│
└── nginx-config
    └── Volume mount
        └── /etc/nginx/conf.d/default.conf

Secret
└── db-credentials
    ├── DB_USER → environment variable
    └── DB_USER / DB_PASSWORD → read-only volume

live-config
└── Volume mount
    └── File changes from "hello" → "world"
        without Pod restart
```

## Practice Commands

```bash
kubectl apply -f k8s/app-config-pod.yaml
kubectl apply -f k8s/nginx-config-pod.yaml
kubectl apply -f k8s/secret-pod.yaml
kubectl apply -f k8s/live-config-pod.yaml

kubectl get configmaps
kubectl get secrets
kubectl get pods

kubectl exec app-config-pod -- env | grep '^APP_'

kubectl exec nginx-config-pod -- cat /etc/nginx/conf.d/default.conf
kubectl exec nginx-config-pod -- wget -qO- http://localhost/health

kubectl exec secret-pod -- sh -c 'echo "$DB_USER"'
kubectl exec secret-pod -- cat /etc/db-credentials/DB_PASSWORD

kubectl exec live-config-pod -- cat /etc/live-config/message
```

## Cleanup

```bash
kubectl delete pod app-config-pod nginx-config-pod secret-pod live-config-pod
kubectl delete configmap app-config nginx-config live-config
kubectl delete secret db-credentials
```
