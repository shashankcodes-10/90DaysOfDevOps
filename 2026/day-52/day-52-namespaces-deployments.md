# Day 52 – Kubernetes Namespaces and Deployments

## Task

Today I learned how Kubernetes **Namespaces** organize resources and how **Deployments** keep applications running with a desired number of replicas. I also practiced self-healing, scaling, rolling updates, rollback, and working with resources across namespaces.

---

## Task 1: Explore Default Namespaces

I first checked the namespaces available in the cluster:

```bash
kubectl get namespaces
```

Kubernetes provides several built-in namespaces:

| Namespace | Purpose |
|---|---|
| `default` | Default namespace used when no namespace is specified. |
| `kube-system` | Contains Kubernetes system components. |
| `kube-public` | Contains resources that can be publicly readable within the cluster. |
| `kube-node-lease` | Contains Lease objects used for node heartbeat information. |

To inspect Kubernetes system Pods:

```bash
kubectl get pods -n kube-system
```

The `kube-system` namespace contains components required for the Kubernetes cluster to operate.

---

# Task 2: Create and Use Custom Namespaces

I created separate namespaces for development and staging:

```bash
kubectl create namespace dev
kubectl create namespace staging
```

I also prepared a manifest that defines `dev`, `staging`, and `production`.

## Namespace Manifest: `namespace.yaml`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
---
apiVersion: v1
kind: Namespace
metadata:
  name: staging
---
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

The manifest can be applied using:

```bash
kubectl apply -f namespace.yaml
```

Verify:

```bash
kubectl get namespaces
```

### Running Pods in Different Namespaces

I can create Pods in specific namespaces:

```bash
kubectl run nginx-dev --image=nginx:latest -n dev
kubectl run nginx-staging --image=nginx:latest -n staging
```

Check Pods in all namespaces:

```bash
kubectl get pods -A
```

Running:

```bash
kubectl get pods
```

without `-n` only displays Pods from the current/default namespace.

To inspect a specific namespace:

```bash
kubectl get pods -n dev
kubectl get pods -n staging
```

### Verification

`kubectl get pods` does not show Pods from `dev` or `staging` because it only queries the current namespace. `kubectl get pods -A` displays Pods across all namespaces.

---

# Task 3: Create the First Deployment

A Deployment manages a set of Pods and maintains the desired number of replicas.

## Deployment Manifest: `nginx-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
```

Apply:

```bash
kubectl apply -f nginx-deployment.yaml
```

Check the Deployment:

```bash
kubectl get deployments -n dev
```

Check its Pods:

```bash
kubectl get pods -n dev
```

Check the ReplicaSet created by the Deployment:

```bash
kubectl get replicasets -n dev
```

### Deployment Manifest Explanation

| Section | Explanation |
|---|---|
| `apiVersion: apps/v1` | API version used by Deployments. |
| `kind: Deployment` | Specifies that the resource is a Deployment. |
| `metadata.name` | Gives the Deployment its name. |
| `metadata.namespace` | Places the Deployment inside the `dev` namespace. |
| `metadata.labels` | Adds labels to identify the Deployment. |
| `replicas: 3` | Requests three running replicas. |
| `selector.matchLabels` | Tells the Deployment which Pods it manages. |
| `template` | Defines the Pod blueprint used to create Pods. |
| `template.metadata.labels` | Labels the Pods created by the Deployment. |
| `containers` | Defines the containers that run inside each Pod. |
| `image: nginx:1.24` | Specifies the Nginx container image and version. |
| `containerPort: 80` | Documents the port exposed by the Nginx container. |

### Important Selector Rule

The Deployment selector:

```yaml
selector:
  matchLabels:
    app: nginx
```

must match the labels in:

```yaml
template:
  metadata:
    labels:
      app: nginx
```

This connects the Deployment to the Pods it manages.

---

# Task 4: Self-Healing

One of the major advantages of a Deployment is that it maintains the desired number of replicas.

First check the Pods:

```bash
kubectl get pods -n dev
```

Delete one Pod:

```bash
kubectl delete pod <pod-name> -n dev
```

Then check again:

```bash
kubectl get pods -n dev
```

The Deployment controller notices that the actual number of Pods is below the desired number of replicas. It creates a replacement Pod.

### Verification

The replacement Pod receives a **different name** because it is a newly created Pod.

The Deployment itself remains, and the Deployment's ReplicaSet creates the replacement Pod.

---

# Deployment vs Standalone Pod

| Standalone Pod | Pod Managed by Deployment |
|---|---|
| No controller maintains it | Deployment/ReplicaSet maintains it |
| Deleting it removes it | Deleting it causes a replacement Pod to be created |
| No desired replica count | Desired replica count can be configured |
| Not suitable for most production applications | Common way to run stateless applications |
| Manual recovery is required | Kubernetes automatically works toward the desired state |

---

# Task 5: Scale the Deployment

Initially the Deployment has:

```yaml
replicas: 3
```

## Imperative Scaling

Scale up to five replicas:

```bash
kubectl scale deployment nginx-deployment --replicas=5 -n dev
```

Check:

```bash
kubectl get pods -n dev
```

Scale down to two replicas:

```bash
kubectl scale deployment nginx-deployment --replicas=2 -n dev
```

Check again:

```bash
kubectl get pods -n dev
```

When scaling down from five to two, Kubernetes terminates three Pods so that the actual number of replicas matches the desired count.

## Declarative Scaling

The number of replicas can also be changed in the YAML:

```yaml
spec:
  replicas: 4
```

Then apply the updated manifest:

```bash
kubectl apply -f nginx-deployment.yaml
```

Kubernetes adjusts the number of Pods to match the new desired state.

### Imperative vs Declarative Scaling

```text
Imperative:
kubectl scale deployment nginx-deployment --replicas=5 -n dev

Declarative:
Edit:
  replicas: 5

Then:
kubectl apply -f nginx-deployment.yaml
```

The declarative approach keeps the desired configuration in version-controlled YAML.

---

# Task 6: Rolling Update

I updated the Nginx image using:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

Check rollout status:

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Kubernetes creates a new ReplicaSet for the updated Pod template and gradually replaces the old Pods.

Check the Deployment:

```bash
kubectl get deployment nginx-deployment -n dev
```

Check ReplicaSets:

```bash
kubectl get replicasets -n dev
```

Check Pod images:

```bash
kubectl describe deployment nginx-deployment -n dev | grep Image
```

### Rollout History

```bash
kubectl rollout history deployment/nginx-deployment -n dev
```

This shows the revisions associated with changes to the Deployment.

---

# Task 7: Rollback

To return to the previous Deployment revision:

```bash
kubectl rollout undo deployment/nginx-deployment -n dev
```

Check the rollout:

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Verify the image:

```bash
kubectl describe deployment nginx-deployment -n dev | grep Image
```

After the rollback, the Deployment returns to the previous Pod template revision.

In this exercise, that means the Deployment returns from:

```text
nginx:1.25
```

to:

```text
nginx:1.24
```

---

# Task 8: Deployment Status

The following command displays Deployment status:

```bash
kubectl get deployments -n dev
```

Important columns include:

| Column | Meaning |
|---|---|
| `READY` | Number of ready replicas compared with the desired replicas. |
| `UP-TO-DATE` | Number of replicas using the latest Deployment configuration. |
| `AVAILABLE` | Number of replicas currently available to serve the application. |

For example:

```text
NAME              READY   UP-TO-DATE   AVAILABLE
nginx-deployment  3/3     3            3
```

This indicates that three replicas are desired, all three use the current configuration, and all three are available.

---

# Task 9: Resources Across Namespaces

To see Deployments in all namespaces:

```bash
kubectl get deployments -A
```

To see Pods in all namespaces:

```bash
kubectl get pods -A
```

To see only the `dev` namespace:

```bash
kubectl get deployments -n dev
kubectl get pods -n dev
```

To see only the `staging` namespace:

```bash
kubectl get pods -n staging
```

This demonstrates how namespaces provide logical separation of resources inside a Kubernetes cluster.

---

# Task 10: Clean Up

Delete the Deployment:

```bash
kubectl delete deployment nginx-deployment -n dev
```

Delete the manually created Pods:

```bash
kubectl delete pod nginx-dev -n dev
kubectl delete pod nginx-staging -n staging
```

Delete the namespaces:

```bash
kubectl delete namespace dev staging production
```

Verify:

```bash
kubectl get namespaces
kubectl get pods -A
```

Deleting a namespace also deletes the resources contained inside that namespace.

Because of this, namespace deletion should be performed carefully, especially in production environments.

---

# Useful Commands Learned

```bash
# List namespaces
kubectl get namespaces

# List Pods in a namespace
kubectl get pods -n dev

# List resources across namespaces
kubectl get pods -A
kubectl get deployments -A

# Create a namespace
kubectl create namespace dev

# Apply a manifest
kubectl apply -f namespace.yaml

# Create a Deployment
kubectl apply -f nginx-deployment.yaml

# List Deployments
kubectl get deployments -n dev

# List ReplicaSets
kubectl get replicasets -n dev

# Scale a Deployment
kubectl scale deployment nginx-deployment --replicas=5 -n dev

# Update an image
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev

# Check rollout
kubectl rollout status deployment/nginx-deployment -n dev

# View rollout history
kubectl rollout history deployment/nginx-deployment -n dev

# Roll back
kubectl rollout undo deployment/nginx-deployment -n dev
```

---

# Key Takeaways

- Namespaces provide logical separation and organization of Kubernetes resources.
- `kubectl get pods` only shows resources in the current namespace.
- `kubectl get pods -A` shows Pods across all namespaces.
- A Deployment maintains a desired number of Pod replicas.
- Deployments use ReplicaSets to manage Pods.
- Deleting a Deployment-managed Pod causes a replacement Pod to be created.
- Scaling changes the desired number of replicas.
- Rolling updates gradually replace Pods with the new configuration.
- Rollbacks allow a Deployment to return to a previous revision.
- Namespace deletion removes resources contained within that namespace.

---

# Files Created

```text
2026/
└── day-52/
    ├── day-52-namespaces-deployments.md
    ├── namespace.yaml
    ├── nginx-deployment.yaml
    └── (YAML and Markdown files only)
```

---

# Submission

Add the Day 52 files:

```bash
git add 2026/day-52/
```

Commit:

```bash
git commit -m "Add Day 52 Kubernetes namespaces and deployments"
```

Push:

```bash
git push origin master
```

---

# Learn in Public

Learned Kubernetes Namespaces and Deployments today. Created self-healing deployments, scaled them up and down, and performed a rolling update with rollback.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
