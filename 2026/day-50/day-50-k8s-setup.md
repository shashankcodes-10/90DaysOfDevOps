# Day 50 – Kubernetes Architecture and Cluster Setup

## Task

Today I started my Kubernetes journey by understanding the Kubernetes architecture, setting up a local cluster using **kind (Kubernetes in Docker)**, and practicing basic `kubectl` commands.

---

## Task 1: Recall the Kubernetes Story

### 1. Why was Kubernetes created?

Docker makes it easy to build and run containers, but running hundreds or thousands of containers across multiple machines becomes difficult to manage manually. Kubernetes was created to automate container orchestration, including scheduling containers, scaling applications, service discovery, networking, and maintaining the desired state of applications.

### 2. Who created Kubernetes and what was it inspired by?

Kubernetes was originally created at **Google** and was influenced by Google's internal container-management system called **Borg**. Kubernetes was later released as an open-source project.

### 3. What does "Kubernetes" mean?

The word **Kubernetes** comes from Greek and means **"helmsman" or "pilot"** — someone who steers a ship. The name represents Kubernetes' role in steering and managing containerized workloads.

---

## Task 2: Kubernetes Architecture

### Architecture Diagram

```text
                         Kubernetes Cluster
                                |
                                |
                  +-------------+-------------+
                  |       Control Plane       |
                  |                           |
                  |  +---------------------+  |
                  |  |     API Server       |  |
                  |  +----------+----------+  |
                  |             |             |
                  |  +----------v----------+  |
                  |  |        etcd         |  |
                  |  |  Cluster State/DB    |  |
                  |  +---------------------+  |
                  |                           |
                  |  +---------------------+  |
                  |  |      Scheduler       |  |
                  |  +---------------------+  |
                  |                           |
                  |  +---------------------+  |
                  |  | Controller Manager   |  |
                  |  +---------------------+  |
                  +-------------+-------------+
                                |
                +---------------+---------------+
                |                               |
       +--------v---------+            +--------v---------+
       |   Worker Node    |            |   Worker Node    |
       |                  |            |                  |
       |    kubelet       |            |    kubelet       |
       |       |          |            |       |          |
       |    kube-proxy    |            |    kube-proxy    |
       |       |          |            |       |          |
       | Container Runtime|            | Container Runtime|
       |       |          |            |       |          |
       |      Pods        |            |      Pods        |
       +------------------+            +------------------+
```

### Control Plane Components

| Component | Responsibility |
|---|---|
| **API Server** | Front door of the Kubernetes cluster. It receives and processes requests from `kubectl` and other clients. |
| **etcd** | Distributed key-value store that keeps Kubernetes cluster state and configuration. |
| **Scheduler** | Selects a suitable worker node for newly created Pods. |
| **Controller Manager** | Runs controllers that continuously compare the desired state with the actual cluster state and take corrective action. |

### Worker Node Components

| Component | Responsibility |
|---|---|
| **kubelet** | Agent running on each node that communicates with the API server and makes sure Pods and containers are running as specified. |
| **kube-proxy** | Maintains networking rules that allow Kubernetes Services to route traffic to Pods. |
| **Container Runtime** | Software responsible for running containers, such as containerd or CRI-O. |
| **Pods** | The smallest deployable units in Kubernetes. They contain one or more containers. |

### What happens when `kubectl apply -f pod.yaml` is executed?

```text
kubectl
   |
   v
API Server
   |
   v
Validate + Store desired state
   |
   v
etcd
   |
   v
Scheduler notices unscheduled Pod
   |
   v
Selects a Worker Node
   |
   v
kubelet on selected Worker Node
   |
   v
Container Runtime
   |
   v
Container/Pod starts
```

The API server is the main entry point. The desired state is stored in `etcd`. The scheduler chooses a suitable node, and the kubelet on that node asks the container runtime to start the required containers.

### What happens if the API server goes down?

The API server is the main communication point for Kubernetes. If it becomes unavailable, new API requests and most cluster management operations cannot be performed. Existing workloads may continue running because the kubelet and container runtime can continue managing already-running containers, but Kubernetes cannot normally make new control-plane decisions or accept new desired-state changes until the API server becomes available again.

### What happens if a worker node goes down?

The control plane detects that the node is unavailable. Kubernetes can reschedule managed workloads such as Deployment Pods onto healthy worker nodes, depending on the workload configuration and available resources. Pods that were running only on the failed node are unavailable until they are recreated elsewhere.

---

## Task 3: Install kubectl

I used Homebrew on macOS:

```bash
brew install kubectl
```

Verify the installation:

```bash
kubectl version --client
```

Useful command:

```bash
which kubectl
```

---

## Task 4: Set Up the Local Cluster

### Tool Chosen: kind

I chose **kind (Kubernetes in Docker)** because I already use Docker and wanted a lightweight local Kubernetes environment for practicing Kubernetes concepts.

kind runs Kubernetes nodes as Docker containers, which makes it convenient for local development and learning.

### Install kind

```bash
brew install kind
```

### Create the cluster

```bash
kind create cluster --name devops-cluster
```

### Verify the cluster

```bash
kubectl cluster-info
kubectl get nodes
```

Expected result:

```text
NAME                         STATUS   ROLES           AGE   VERSION
devops-cluster-control-plane Ready    control-plane   ...   v1.x.x
```



---

## Task 5: Explore the Cluster

### Cluster information

```bash
kubectl cluster-info
```

### List nodes

```bash
kubectl get nodes
```

### Get detailed node information

```bash
kubectl describe node devops-cluster-control-plane
```

### List namespaces

```bash
kubectl get namespaces
```

### List all Pods in the cluster

```bash
kubectl get pods -A
```

### Check kube-system Pods

```bash
kubectl get pods -n kube-system
```


### What each kube-system Pod does

| Pod / Component | Purpose |
|---|---|
| **etcd** | Stores the Kubernetes cluster state and configuration. |
| **kube-apiserver** | Handles Kubernetes API requests and acts as the cluster's front door. |
| **kube-scheduler** | Assigns unscheduled Pods to suitable nodes. |
| **kube-controller-manager** | Runs controllers that maintain the desired state of Kubernetes resources. |
| **kube-proxy** | Maintains networking rules for Kubernetes Services and Pod traffic. |
| **CoreDNS** | Provides DNS-based service discovery inside the Kubernetes cluster. |

### Architecture Verification

The Pods in the `kube-system` namespace helped me connect the architecture diagram with an actual running Kubernetes cluster.

For example:

```text
kube-apiserver            -> API Server
etcd                      -> Cluster State Database
kube-scheduler            -> Scheduler
kube-controller-manager   -> Controller Manager
kube-proxy                -> Node Networking
coredns                   -> Cluster DNS
```

---

## Task 6: Practice Cluster Lifecycle

### Delete the cluster

```bash
kind delete cluster --name devops-cluster
```

### Recreate the cluster

```bash
kind create cluster --name devops-cluster
```

### Verify it is running again

```bash
kubectl get nodes
```

### Check the current context

```bash
kubectl config current-context
```

For the kind cluster, the context is normally:

```text
kind-devops-cluster
```

### List all contexts

```bash
kubectl config get-contexts
```

### View kubeconfig

```bash
kubectl config view
```

---

## What is kubeconfig?

A **kubeconfig** file contains the information that `kubectl` uses to connect to Kubernetes clusters.

It can contain:

- Cluster server/API endpoint information
- Cluster certificates
- User credentials
- Contexts
- The current context

The default kubeconfig location on macOS/Linux is:

```text
~/.kube/config
```

The current context tells `kubectl` which cluster and credentials to use when executing commands.

---

## Useful Commands Learned

```bash
# Check kubectl client
kubectl version --client

# Check cluster information
kubectl cluster-info

# List nodes
kubectl get nodes

# Detailed node information
kubectl describe node <node-name>

# List namespaces
kubectl get namespaces

# List Pods across all namespaces
kubectl get pods -A

# List kube-system Pods
kubectl get pods -n kube-system

# Show additional node details
kubectl get nodes -o wide

# Show current Kubernetes context
kubectl config current-context

# List contexts
kubectl config get-contexts

# List kind clusters
kind get clusters

# Delete kind cluster
kind delete cluster --name devops-cluster

# Create kind cluster
kind create cluster --name devops-cluster
```

---

## Key Takeaways

- Kubernetes is a container orchestration platform.
- The **API Server** is the main entry point to the cluster.
- **etcd** stores the cluster's state.
- The **Scheduler** decides where unscheduled Pods should run.
- **Controller Manager** works to maintain the desired state.
- **kubelet** manages Pods on worker nodes.
- **kube-proxy** handles Service networking rules.
- **CoreDNS** provides service discovery through DNS.
- `kubectl` is the primary CLI used to interact with Kubernetes.
- **kind** provides a convenient local Kubernetes cluster using Docker.
- `~/.kube/config` stores the default kubeconfig.

---


## Learn in Public

Started my Kubernetes journey today. Set up a local cluster using kind, explored the Kubernetes architecture, and used `kubectl` to inspect the cluster and its system components.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
