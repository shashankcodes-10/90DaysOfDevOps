# Day 51 – Kubernetes Manifests and Your First Pods

## Task

Today I created Kubernetes Pod manifests by hand and deployed them to my local Kubernetes cluster. I practiced working with Nginx, BusyBox, and Alpine Pods, explored Pod logs and shells, compared imperative and declarative approaches, validated manifests, and worked with labels.

---

## The Four Required Fields of a Kubernetes Manifest

Every Kubernetes resource manifest starts with four important top-level fields:

| Field | Purpose |
|---|---|
| `apiVersion` | Defines the Kubernetes API version used by the resource. For a Pod, this is `v1`. |
| `kind` | Defines the type of Kubernetes resource. Here it is `Pod`. |
| `metadata` | Contains identifying information such as the resource name and labels. |
| `spec` | Describes the desired state of the resource, including containers, images, ports, commands, and other configuration. |

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx:latest
```

---

# Task 1: First Pod – Nginx

## Manifest: `nginx-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

I applied the manifest using:

```bash
kubectl apply -f nginx-pod.yaml
```

Then checked the Pod:

```bash
kubectl get pods
kubectl get pods -o wide
```

For detailed information:

```bash
kubectl describe pod nginx-pod
```

To view logs:

```bash
kubectl logs nginx-pod
```

To enter the container:

```bash
kubectl exec -it nginx-pod -- /bin/bash
```

Inside the container:

```bash
curl localhost:80
```

If `/bin/bash` is unavailable, `/bin/sh` can be used instead.

The Nginx container serves its default welcome page on port 80.



---

# Task 2: Custom Pod – BusyBox

## Manifest: `busybox-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]
```

Apply:

```bash
kubectl apply -f busybox-pod.yaml
```

Check the Pod:

```bash
kubectl get pods
```

View the logs:

```bash
kubectl logs busybox-pod
```

Expected output includes:

```text
Hello from BusyBox
```

### Why is the `command` important?

Unlike Nginx, BusyBox does not automatically run a long-lived server. Without a long-running command, the container would finish its process and exit.

The command:

```bash
sleep 3600
```

keeps the container running for the exercise.

---

# Task 3: Third Pod – Alpine

I created a third Pod with three labels: `app`, `environment`, and `team`.

## Manifest: `alpine-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: alpine-pod
  labels:
    app: alpine
    environment: dev
    team: platform
spec:
  containers:
  - name: alpine
    image: alpine:latest
    command: ["sh", "-c", "echo Hello from Alpine && sleep 3600"]
```

Apply:

```bash
kubectl apply -f alpine-pod.yaml
```

Verify:

```bash
kubectl get pods --show-labels
```

---

# Task 4: Imperative vs Declarative

Kubernetes provides both imperative and declarative ways to create resources.

## Imperative approach

I can create a Pod directly from the command line:

```bash
kubectl run redis-pod --image=redis:latest
```

The command directly tells Kubernetes what to create.

I can inspect the generated resource with:

```bash
kubectl get pod redis-pod -o yaml
```

## Declarative approach

With the declarative approach, I describe the desired state in a YAML manifest:

```bash
kubectl apply -f nginx-pod.yaml
```

Kubernetes then works toward the state described by the manifest.

### Comparison

| Imperative | Declarative |
|---|---|
| Uses direct commands | Uses YAML manifests |
| Quick for one-off tasks | Better for repeatable configuration |
| Configuration is mainly in the command | Configuration is stored in a file |
| Example: `kubectl run redis-pod --image=redis:latest` | Example: `kubectl apply -f nginx-pod.yaml` |

For Kubernetes configuration that needs to be repeatable and version-controlled, YAML manifests are particularly useful.

---

# Task 5: Generate YAML with Dry Run

I can generate a Pod manifest without actually creating the Pod:

```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml
```

I can save the output to a file:

```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml > test-pod.yaml
```

Example generated structure:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - image: nginx
    name: test-pod
```

### Comparison with my hand-written manifest

The basic structure is the same:

```text
apiVersion
kind
metadata
spec
containers
```

My hand-written Nginx manifest additionally contains labels and a container port. Kubernetes can also add fields automatically when a resource is actually created, such as UID, resource version, timestamps, status, and other runtime information.

---

# Task 6: Validate Before Applying

### Client-side dry run

```bash
kubectl apply -f nginx-pod.yaml --dry-run=client
```

This checks the manifest locally without creating the resource.

### Server-side dry run

```bash
kubectl apply -f nginx-pod.yaml --dry-run=server
```

This sends the request to the Kubernetes API server for server-side validation without persisting the resource.

### Testing an invalid manifest

If the required `image` field is removed or an invalid field is added, Kubernetes rejects the manifest during validation.

For example, a container without an image does not contain enough information for Kubernetes to know which container image should be run, so the API validation reports that the required container image field is missing.

---

# Task 7: Pod Labels and Filtering

Labels allow resources to be organized and selected.

Show all labels:

```bash
kubectl get pods --show-labels
```

Filter by application:

```bash
kubectl get pods -l app=nginx
```

Filter by environment:

```bash
kubectl get pods -l environment=dev
```

Add a label:

```bash
kubectl label pod nginx-pod environment=production
```

Verify:

```bash
kubectl get pods --show-labels
```

Remove the label:

```bash
kubectl label pod nginx-pod environment-
```

Labels are key-value pairs. Kubernetes uses them with selectors to identify groups of resources.

---

# Task 8: Pod Inspection Commands

These commands were used to inspect and troubleshoot Pods:

```bash
# List Pods
kubectl get pods

# List Pods with additional information
kubectl get pods -o wide

# Show labels
kubectl get pods --show-labels

# Describe a Pod
kubectl describe pod nginx-pod

# View logs
kubectl logs nginx-pod

# Open a shell inside a Pod
kubectl exec -it nginx-pod -- /bin/bash

# Alternative shell
kubectl exec -it nginx-pod -- /bin/sh
```

---

# Task 9: Clean Up

Standalone Pods are not managed by a Deployment or another controller. Therefore, deleting one does not cause Kubernetes to recreate it.

Delete individual Pods:

```bash
kubectl delete pod nginx-pod
kubectl delete pod busybox-pod
kubectl delete pod redis-pod
kubectl delete pod alpine-pod
```

Or delete using a manifest:

```bash
kubectl delete -f nginx-pod.yaml
```

Verify:

```bash
kubectl get pods
```

### What happens when a standalone Pod is deleted?

A standalone Pod is permanently removed from the cluster. There is no controller responsible for maintaining a desired number of replicas, so Kubernetes does not automatically recreate it.

This is one reason applications are normally deployed using higher-level controllers such as **Deployments** rather than standalone Pods.

---

# Key Takeaways

- A Kubernetes manifest describes the desired state of a resource.
- The four main manifest fields are `apiVersion`, `kind`, `metadata`, and `spec`.
- A Pod is the smallest deployable unit in Kubernetes.
- `kubectl apply -f` is the declarative way to apply a manifest.
- `kubectl run` is an imperative way to create a resource.
- `--dry-run=client -o yaml` is useful for generating a starting manifest.
- `kubectl describe` is useful for investigating Pod events and configuration.
- `kubectl logs` shows container output.
- `kubectl exec` allows interaction with a running container.
- Labels can be used to organize and filter Kubernetes resources.
- A standalone Pod is not automatically recreated after deletion.

---

# Files Created

```text
2026/
└── day-51/
    ├── day-51-pods.md
    ├── nginx-pod.yaml
    ├── busybox-pod.yaml
    ├── alpine-pod.yaml
    ├── test-pod.yaml
```

---



# Learn in Public

Wrote my first Kubernetes Pod manifests from scratch today. Created Pods, got a shell inside them, practiced labels and validation, and learned the difference between imperative and declarative approaches.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
