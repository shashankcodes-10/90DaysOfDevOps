# Day 54 – Kubernetes ConfigMaps and Secrets

Practice project for Kubernetes ConfigMaps and Secrets.

## Contents

- ConfigMap created from literals
- ConfigMap created from an Nginx configuration file
- ConfigMap consumed through environment variables
- ConfigMap mounted as a volume
- Secret created from literals
- Secret consumed through `secretKeyRef`
- Secret mounted as a read-only volume
- Live ConfigMap volume update demonstration

## Files

```text
k8s/
├── app-config-pod.yaml
├── default.conf
├── live-config-pod.yaml
├── nginx-config-pod.yaml
└── secret-pod.yaml

2026/day-54/
└── day-54-configmaps-secrets.md
```

## Quick Start

Create the resources:

```bash
kubectl create configmap app-config   --from-literal=APP_ENV=production   --from-literal=APP_DEBUG=false   --from-literal=APP_PORT=8080

kubectl create configmap nginx-config   --from-file=default.conf=k8s/default.conf

kubectl create secret generic db-credentials   --from-literal=DB_USER=admin   --from-literal=DB_PASSWORD='s3cureP@ssw0rd'

kubectl create configmap live-config --from-literal=message=hello
```

Then apply the Pods:

```bash
kubectl apply -f k8s/app-config-pod.yaml
kubectl apply -f k8s/nginx-config-pod.yaml
kubectl apply -f k8s/secret-pod.yaml
kubectl apply -f k8s/live-config-pod.yaml
```
