# Day 30 – Docker Images & Container Lifecycle

## Task

Today's goal was to understand how Docker images and containers work, including:

* The relationship between images and containers
* Docker image sizes and layers
* Image history and caching
* The complete container lifecycle
* Working with running containers
* Container inspection and networking
* Docker cleanup and disk usage

---

# Task 1 – Docker Images

## 1. Pull Docker Images

I pulled the following images from Docker Hub:

### Pull Nginx

```bash
docker pull nginx
```

The `nginx:latest` image was successfully downloaded.

### Pull Ubuntu

```bash
docker pull ubuntu
```

The `ubuntu:latest` image was successfully downloaded.

### Pull Alpine

```bash
docker pull alpine
```

The `alpine:latest` image was successfully downloaded.

All three images were successfully pulled from Docker Hub.

---

## 2. List Docker Images

Command used:

```bash
docker images
```

Relevant image sizes from my system:

| Image           | Disk Usage | Content Size |
| --------------- | ---------: | -----------: |
| `alpine:latest` |    13.6 MB |      4.27 MB |
| `ubuntu:latest` |     179 MB |      44.4 MB |
| `nginx:latest`  |     259 MB |      64.5 MB |

I also had several previously created application images on my system.

### Observation

The Alpine image is significantly smaller than Ubuntu.

---

## 3. Ubuntu vs Alpine

### Why is Alpine much smaller?

Alpine Linux is designed to be a very small and minimal Linux distribution.

It contains only the essential components required to run applications.

Ubuntu is a more feature-rich general-purpose Linux distribution and includes considerably more packages and utilities.

Therefore:

```text
Alpine → Minimal Linux distribution → Smaller image

Ubuntu → More packages and utilities → Larger image
```

The smaller size of Alpine can be useful when building lightweight Docker images, especially when the application does not require the additional packages provided by larger distributions.

---

## 4. Inspect an Image

Docker provides image inspection functionality through:

```bash
docker image inspect nginx
```

Image inspection can provide information such as:

* Image ID
* Image configuration
* Environment variables
* Architecture
* Operating system
* Entrypoint
* Default command
* Exposed ports
* Layers
* Image metadata
* Image creation information

The Nginx image used in this practical was a Linux `arm64` image.

---

## 5. Image Removal

Docker provides the following command for removing an image:

```bash
docker rmi <image-name>
```

Example:

```bash
docker rmi <image-name>
```

An image should only be removed when it is no longer required and is not being used by a container.

---

# Task 2 – Docker Image Layers

## Image History

Command used:

```bash
docker image history nginx
```

The output showed multiple entries representing the history of the Nginx image.

Some entries had actual sizes, while others showed `0B`.

Example observations:

```text
CMD                              0B
STOPSIGNAL                       0B
EXPOSE                           0B
ENTRYPOINT                       0B
COPY                             16.4kB
COPY                             12.3kB
COPY                             12.3kB
COPY                             12.3kB
RUN                              85.3MB
Base Debian layer                109MB
```

---

## What Are Docker Image Layers?

Docker images are built using multiple filesystem layers.

Each instruction that changes the filesystem can create a new layer.

For example:

```dockerfile
FROM ubuntu
RUN apt-get update
COPY app.py /app/
```

Conceptually:

```text
        Docker Image
             |
     +---------------+
     |   COPY layer  |
     +---------------+
             |
     +---------------+
     |    RUN layer  |
     +---------------+
             |
     +---------------+
     |  Ubuntu layer |
     +---------------+
```

Docker combines these layers to create the final image.

---

## Why Does Docker Use Layers?

Docker uses layers for several important reasons.

### 1. Reusability

Layers can be shared between different images.

### 2. Caching

Docker can reuse unchanged layers during image builds instead of rebuilding everything.

### 3. Faster Builds

If only one part of a Dockerfile changes, Docker can reuse the previous layers and rebuild only the affected parts.

### 4. Storage Efficiency

Shared layers do not need to be stored multiple times.

---

## Why Do Some Layers Show 0B?

Some Dockerfile instructions change image metadata rather than adding files to the filesystem.

For example:

```dockerfile
CMD
ENV
EXPOSE
ENTRYPOINT
STOPSIGNAL
```

These instructions can appear as `0B` in `docker image history` because they do not add a significant filesystem layer.

---

# Task 3 – Container Lifecycle

For the lifecycle practical, I used an Nginx container named:

```text
nginx-container
```

Container ID used during the practical:

```text
b01e63d8ee6c
```

A later Nginx container was created for the running-container exercises:

```text
e53a6c9b3416
```

---

## Container Lifecycle

The lifecycle practiced was:

```text
Create
  ↓
Start
  ↓
Pause
  ↓
Unpause
  ↓
Stop
  ↓
Restart
  ↓
Kill
  ↓
Remove
```

---

## 1. Create and Start the Container

The Nginx container was created and started using:

```bash
docker run -d --name nginx-container nginx
```

The container started successfully.

Check running containers:

```bash
docker ps
```

Output showed:

```text
CONTAINER ID   IMAGE   STATUS       PORTS   NAMES
b01e63d8ee6c   nginx   Up ...       80/tcp  nginx-container
```

---

## 2. Pause the Container

Command:

```bash
docker pause b01e63
```

Check status:

```bash
docker ps
```

The container state changed to:

```text
Up ... (Paused)
```

This demonstrates that a paused container still exists and remains running from Docker's perspective, but its processes are temporarily suspended.

---

## 3. Unpause the Container

Command:

```bash
docker unpause b01e63
```

Check status:

```bash
docker ps
```

The container returned to:

```text
Up
```

---

## 4. Stop the Container

Command:

```bash
docker stop b01e6
```

Check all containers:

```bash
docker ps -a
```

The container state became:

```text
Exited (0)
```

A stopped container still exists and can be started again.

---

## 5. Restart the Container

Command:

```bash
docker restart b01e6
```

Check:

```bash
docker ps
```

The container returned to:

```text
Up
```

---

## 6. Kill the Container

Command:

```bash
docker kill b01e6
```

Check:

```bash
docker ps -a
```

The container exited with:

```text
Exited (137)
```

This demonstrates the difference between stopping and killing a container.

`docker stop` gracefully stops a container, while `docker kill` immediately sends a kill signal to the container's main process.

---

## 7. Remove the Container

Command:

```bash
docker rm b01e63
```

Check:

```bash
docker ps -a
```

The container was removed successfully.

---

# Task 4 – Working with Running Containers

A new Nginx container was started in detached mode:

```bash
docker run -d --name nginx-container nginx
```

Container ID:

```text
e53a6c9b3416
```

Check the running container:

```bash
docker ps
```

The container was running successfully.

---

## 1. View Container Logs

Command:

```bash
docker logs e53a6c
```

The logs showed Nginx startup information including:

```text
nginx/1.31.4
using the "epoll" event method
start worker processes
```

The logs also showed the Nginx entrypoint scripts being executed during startup.

---

## 2. Follow Logs in Real Time

Command:

```bash
docker logs -f e53a6c
```

The `-f` option means **follow**.

It keeps the terminal attached to the container logs and displays new log entries as they are generated.

I exited follow mode using:

```text
Ctrl + C
```

---

## 3. Execute a Shell Inside the Container

Command:

```bash
docker exec -it e53a6c bash
```

Inside the container, I checked the root filesystem:

```bash
ls
```

The filesystem contained directories such as:

```text
bin
boot
dev
etc
home
lib
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
```

I also inspected:

```bash
cd docker-entrypoint.d
ls
```

The directory contained Nginx startup scripts.

Finally, I exited the container:

```bash
exit
```

---

## 4. Execute a Single Command Inside the Container

Docker allows commands to be executed directly inside a running container without opening an interactive shell.

Example:

```bash
docker exec e53a6c df -h
```

The command displayed filesystem usage from inside the container.

The output showed:

```text
Filesystem      Size  Used Avail Use%
overlay         453G  9.1G  421G   3%
tmpfs            64M     0   64M   0%
shm              64M     0   64M   0%
```

This demonstrates that `docker exec` can be used to run individual commands inside a running container.

---

## 5. Inspect the Container

Command:

```bash
docker inspect e53a6c
```

`docker inspect` returned detailed information about the container.

Important information found during the inspection included:

### Container Status

```text
Status: running
Running: true
Paused: false
Restarting: false
OOMKilled: false
ExitCode: 0
```

### Container Name

```text
/nginx-container
```

### Image

```text
nginx
```

Image digest:

```text
sha256:0d4374c710a9649200e84f8ef8dbdd4fa76c0c107839cd50f1e42a63916b0f2e
```

### Network

The container was connected to the default Docker bridge network:

```text
NetworkMode: bridge
```

### Container IP Address

The container received the following IP address:

```text
172.17.0.2
```

### Gateway

```text
172.17.0.1
```

### Exposed Port

Nginx exposes:

```text
80/tcp
```

However, no host port was published because the container was started without `-p`.

Therefore:

```text
80/tcp → Exposed inside the container
```

but there was no host mapping such as:

```text
8080:80
```

### Mounts

The inspection showed:

```text
Mounts: []
```

Therefore, this container did not have any Docker volumes or bind mounts attached.

---

# Task 5 – Cleanup

## 1. Stop All Running Containers

Command used:

```bash
docker stop $(docker ps -q)
```

The running Nginx container was stopped.

---

## 2. Remove Stopped Containers

Command:

```bash
docker container prune
```

Docker asked for confirmation:

```text
WARNING! This will remove all stopped containers.
```

After confirmation, the stopped Nginx container was removed.

Reclaimed space:

```text
86.02kB
```

---

## 3. Remove Unused Images

Command:

```bash
docker image prune
```

This removes dangling images that are no longer referenced.

In this practical:

```text
Total reclaimed space: 0B
```

This means there were no dangling images that could be removed.

---

## 4. Check Docker Disk Usage

Command:

```bash
docker system df
```

The final Docker disk usage was:

| Resource      | Total | Active |     Size |     Reclaimable |
| ------------- | ----: | -----: | -------: | --------------: |
| Images        |    16 |      0 | 3.359 GB |   2.87 GB (85%) |
| Containers    |     0 |      0 |      0 B |             0 B |
| Local Volumes |     2 |      0 | 507.1 MB | 507.1 MB (100%) |
| Build Cache   |   309 |      0 | 6.242 GB |        4.171 GB |

### Observation

The build cache was using the largest amount of Docker storage:

```text
Build Cache → 6.242 GB
```

The images were using:

```text
3.359 GB
```

The local volumes were using:

```text
507.1 MB
```

This shows that Docker storage is not limited to images and containers. Build cache and volumes can also consume significant disk space.

---

# Important Docker Commands Learned

## Images

```bash
docker pull <image>
docker images
docker image inspect <image>
docker image history <image>
docker rmi <image>
docker image prune
```

## Containers

```bash
docker run -d --name <name> <image>
docker ps
docker ps -a
docker stop <container>
docker start <container>
docker restart <container>
docker pause <container>
docker unpause <container>
docker kill <container>
docker rm <container>
```

## Container Interaction

```bash
docker logs <container>
docker logs -f <container>
docker exec -it <container> bash
docker exec <container> <command>
docker inspect <container>
```

## Cleanup and Storage

```bash
docker stop $(docker ps -q)
docker container prune
docker image prune
docker system df
docker system prune
```

---

# Key Learnings

### 1. Image vs Container

A Docker **image** is a read-only template used to create containers.

A **container** is a running or stopped instance created from an image.

```text
Docker Image
     ↓
 Container
```

Multiple containers can be created from the same image.

---

### 2. Images Are Layered

Docker images consist of multiple layers.

Layers can be reused and cached, which helps Docker build and distribute images efficiently.

---

### 3. Containers Have Different States

During the practical, the container went through several states:

```text
Created/Started
      ↓
Running
      ↓
Paused
      ↓
Running
      ↓
Exited
      ↓
Running
      ↓
Killed / Exited
      ↓
Removed
```

Understanding these states is important when troubleshooting Docker containers.

---

### 4. `docker stop` vs `docker kill`

`docker stop` attempts to gracefully stop the container.

```bash
docker stop <container>
```

`docker kill` immediately terminates the container's main process.

```bash
docker kill <container>
```

The killed container in this practical exited with code:

```text
137
```

---

### 5. `docker exec`

`docker exec` allows commands to be executed inside an already running container.

Interactive shell:

```bash
docker exec -it <container> bash
```

Single command:

```bash
docker exec <container> df -h
```

---

### 6. `docker inspect`

`docker inspect` is useful when troubleshooting because it provides detailed container configuration and runtime information.

It can reveal:

* Container state
* Image
* IP address
* Network configuration
* Port configuration
* Mounts
* Environment variables
* Entrypoint
* Command
* Restart policy

---

# What Surprised Me

One thing that stood out during this practical was how much information Docker keeps about a container.

A simple Nginx container had information about its image, filesystem, network, IP address, environment variables, entrypoint, exposed ports, runtime state, and other configuration.

Another important observation was the difference between the image's **content size** and **disk usage** shown by `docker images`.

The image layers also made it clear why Docker can reuse previously built content instead of rebuilding an entire image every time.

---

# Screenshots

The following screenshots should be added to the repository as evidence of the practical:

1. Docker images after pulling Nginx, Ubuntu, and Alpine
2. `docker image history nginx`
3. Container running with `docker ps`
4. Container paused with `docker ps`
5. Container stopped with `docker ps -a`
6. Container restarted with `docker ps`
7. Container killed with `docker ps -a`
8. `docker logs`
9. `docker logs -f`
10. `docker exec -it`
11. `docker inspect`
12. `docker system df`

---

# Conclusion

Day 30 helped me understand Docker beyond simply running containers.

I practiced working with Docker images, explored image layers, observed the complete container lifecycle, inspected a running Nginx container, viewed its logs, executed commands inside it, checked its networking information, and cleaned up Docker resources.

The main takeaway is that Docker images provide the reusable foundation, while containers are runtime instances created from those images. Understanding their lifecycle and internal configuration is essential for troubleshooting and managing containerized applications.

---

## Commands Practiced

```bash
docker pull nginx
docker pull ubuntu
docker pull alpine
docker images
docker image history nginx
docker image inspect nginx

docker run -d --name nginx-container nginx
docker ps
docker ps -a
docker pause <container>
docker unpause <container>
docker stop <container>
docker restart <container>
docker kill <container>
docker rm <container>

docker logs <container>
docker logs -f <container>
docker exec -it <container> bash
docker exec <container> df -h
docker inspect <container>

docker stop $(docker ps -q)
docker container prune
docker image prune
docker system df
docker system prune
```

**Day 30 completed — Docker Images & Container Lifecycle.**
