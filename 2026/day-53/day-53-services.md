# Day 53 – Kubernetes Services

## Task

Today I learned how Kubernetes Services provide a stable way to communicate with Pods. Since Pod IP addresses can change when Pods are recreated, Services provide a stable network endpoint and route traffic to the Pods selected by their labels.

I created a Deployment with three Nginx replicas and exposed it using **ClusterIP**, **NodePort**, and **LoadBalancer** Services. I also practiced Kubernetes DNS, Endpoints, and Service-to-Pod communication.

---

# Why Services?

Pods receive their own IP addresses, but Pod IPs are not permanent. A Pod can be deleted and recreated with a different IP address.

A Deployment can also run multiple replicas, so clients should not need to know the IP address of every individual Pod.

A Service solves this by providing a stable network endpoint and selecting the appropriate Pods.

```text
                 Stable Service
                      |
          +-----------+-----------+
          |           |           |
        Pod 1       Pod 2       Pod 3
```

The Service uses a selector to identify the Pods that should receive traffic.

---

# Task 1: Deploy the Application

I created a Deployment with three Nginx replicas.

## `app-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

Apply the Deployment:

```bash
kubectl apply -f app-deployment.yaml
```

Check the Pods:

```bash
kubectl get pods -o wide
```

The Deployment creates three Pods.

The individual Pod IP addresses can be seen with:

```bash
kubectl get pods -o wide
```

These IPs are not intended to be permanent endpoints for clients because Pods can be recreated.

---

# Task 2: ClusterIP Service

ClusterIP is the default Kubernetes Service type. It provides an internal endpoint that can be accessed from within the cluster.

## `clusterip-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Apply:

```bash
kubectl apply -f clusterip-service.yaml
```

Check the Service:

```bash
kubectl get services
```

### Important fields

| Field | Purpose |
|---|---|
| `type: ClusterIP` | Creates an internal-only Service. |
| `selector.app: web-app` | Selects Pods with the `app=web-app` label. |
| `port: 80` | Port exposed by the Service. |
| `targetPort: 80` | Port on the selected Pods receiving traffic. |

### Test Service-to-Pod communication

I can create a temporary BusyBox client:

```bash
kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh
```

Inside the temporary Pod:

```bash
wget -qO- http://web-app-clusterip
```

The request is sent to the ClusterIP Service, which forwards it to one of the matching Nginx Pods.

Exit:

```bash
exit
```

The `--rm` option removes the temporary test Pod after it exits.

---

# Task 3: Kubernetes DNS

Kubernetes provides DNS-based service discovery.

A Service can be reached using a DNS name based on:

```text
<service-name>.<namespace>.svc.cluster.local
```

For a Service in the default namespace:

```text
web-app-clusterip.default.svc.cluster.local
```

A temporary test Pod can be used:

```bash
kubectl run dns-test --image=busybox:latest --rm -it --restart=Never -- sh
```

Inside the Pod:

```bash
wget -qO- http://web-app-clusterip
```

Full DNS name:

```bash
wget -qO- http://web-app-clusterip.default.svc.cluster.local
```

DNS lookup:

```bash
nslookup web-app-clusterip
```

The DNS name resolves to the Service's ClusterIP.

### Short name vs Full DNS Name

Within the same namespace, the short Service name is normally sufficient:

```text
web-app-clusterip
```

The full DNS name can be used when a specific namespace needs to be included:

```text
web-app-clusterip.default.svc.cluster.local
```

---

# Task 4: NodePort Service

A NodePort Service exposes the Service through a port on each node.

## `nodeport-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

Apply:

```bash
kubectl apply -f nodeport-service.yaml
```

Check:

```bash
kubectl get services
```

The important port is:

```text
30080
```

The traffic path is:

```text
<NodeIP>:30080
       |
       v
NodePort Service
       |
       v
Pod:80
```

The NodePort range is normally:

```text
30000-32767
```

For a local cluster, access depends on the Kubernetes environment. With a suitable kind configuration or node networking setup, the NodePort can be tested using the node address and port.

For example:

```bash
curl http://<node-ip>:30080
```

---

# Task 5: LoadBalancer Service

A LoadBalancer Service is commonly used to expose applications externally in cloud Kubernetes environments.

## `loadbalancer-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Apply:

```bash
kubectl apply -f loadbalancer-service.yaml
```

Check:

```bash
kubectl get services
```

In a cloud Kubernetes environment, a LoadBalancer Service can request an external load balancer from the cloud provider.

On many local Kubernetes clusters, there is no cloud provider integration, so the `EXTERNAL-IP` can remain:

```text
<pending>
```

This is expected when no external load balancer implementation is available.

---

# Task 6: Service Types Compared

```bash
kubectl get services -o wide
```

| Type | Accessibility | Typical Use |
|---|---|---|
| **ClusterIP** | Internal cluster access | Communication between applications/services |
| **NodePort** | Through a node IP and port | Development and testing |
| **LoadBalancer** | External load balancer when supported | External applications in cloud environments |

### Traffic Overview

```text
ClusterIP:

Inside Cluster
     |
     v
[ClusterIP Service]
     |
     +----> Pod
     +----> Pod
     +----> Pod


NodePort:

Client
  |
  v
[NodeIP:30080]
  |
  v
[NodePort Service]
  |
  +----> Pod
  +----> Pod
  +----> Pod


LoadBalancer:

External Client
      |
      v
[External Load Balancer]
      |
      v
[LoadBalancer Service]
      |
      +----> Pod
      +----> Pod
      +----> Pod
```

A LoadBalancer Service generally also has a ClusterIP and, where applicable, a NodePort allocated for the Service.

Inspect it with:

```bash
kubectl describe service web-app-loadbalancer
```

---

# Task 7: Endpoints

Endpoints represent the network addresses of Pods selected by a Service.

Check the endpoints for the ClusterIP Service:

```bash
kubectl get endpoints web-app-clusterip
```

You can also inspect them with:

```bash
kubectl describe service web-app-clusterip
```

The endpoints should correspond to the Pods selected by:

```yaml
selector:
  app: web-app
```

A useful way to think about the relationship is:

```text
Service Selector
      |
      v
Pods with app=web-app
      |
      v
Pod IP:Port endpoints
```

If a Service has no matching Pods, it will not have useful backend endpoints.

---

# Task 8: Verify the Service Selector

The Deployment creates Pods with:

```yaml
labels:
  app: web-app
```

The Services use:

```yaml
selector:
  app: web-app
```

Because the labels and selector match, the Services can route traffic to the Deployment's Pods.

Check Pod labels:

```bash
kubectl get pods --show-labels
```

Check Service details:

```bash
kubectl describe service web-app-clusterip
```

---

# Task 9: Clean Up

Delete the Deployment:

```bash
kubectl delete -f app-deployment.yaml
```

Delete the Services:

```bash
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml
```

Verify:

```bash
kubectl get pods
kubectl get services
```

After cleanup, the custom application resources should be removed. The built-in `kubernetes` Service in the default namespace normally remains.

---

# Useful Commands Learned

```bash
# Apply a Deployment
kubectl apply -f app-deployment.yaml

# List Pods
kubectl get pods -o wide

# List Services
kubectl get services

# List Services with additional information
kubectl get services -o wide

# Test a Service from inside the cluster
kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh

# Check DNS
nslookup web-app-clusterip

# Check Service endpoints
kubectl get endpoints web-app-clusterip

# Describe a Service
kubectl describe service web-app-clusterip

# Delete application resources
kubectl delete -f app-deployment.yaml
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml
```

---

# Key Takeaways

- Pod IPs can change when Pods are recreated.
- Services provide stable networking for Pods.
- A Service uses selectors to identify its backend Pods.
- **ClusterIP** provides internal cluster access.
- **NodePort** exposes a Service through a port on Kubernetes nodes.
- **LoadBalancer** can provide external access when supported by the cluster/cloud environment.
- Kubernetes automatically provides DNS records for Services.
- Endpoints show the Pod addresses currently selected by a Service.
- `port` is the Service port, while `targetPort` is the destination Pod port.
- Services can distribute traffic across multiple matching Pods.

---


# Learn in Public

Learned Kubernetes Services today — ClusterIP for internal traffic, NodePort for node-level access, and LoadBalancer for external access. Services give Pods a stable network identity and provide traffic routing to the application replicas.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
