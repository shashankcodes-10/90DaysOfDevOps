# Day 29 – Docker Basics

## Task

Today I started learning **Docker**, the foundation of modern containerized application deployment.

The main goals were to:

- Understand why containers are used
- Learn the difference between containers and virtual machines
- Understand Docker architecture
- Install and verify Docker
- Run my first Docker container
- Explore real containers such as Nginx and Ubuntu
- Practice basic container management commands

---

# Task 1 – What is Docker?

## What is a Container?

A **container** is a lightweight, isolated environment used to package and run an application along with everything it needs, such as:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration

Containers share the host machine's **OS kernel**, which makes them much lighter and faster to start than virtual machines.

### Why Do We Need Containers?

Containers help solve the common problem:

> "It works on my machine, but it doesn't work on another machine."

With containers, the application and its dependencies are packaged together, making the environment more consistent across:

- Developer machines
- Testing environments
- CI/CD pipelines
- Cloud servers
- Kubernetes clusters

### Important Container Characteristics

- Lightweight
- Fast startup
- Portable
- Isolated
- Reproducible
- Easy to scale

---

# Containers vs Virtual Machines

| Feature | Containers | Virtual Machines |
|---|---|---|
| Virtualization | OS-level virtualization | Hardware-level virtualization |
| Kernel | Share host kernel | Each VM has its own OS/kernel |
| Size | Usually MBs | Usually GBs |
| Startup | Seconds or less | Usually slower |
| Resource usage | Lower | Higher |
| Isolation | Process-level isolation | Stronger full-OS isolation |
| Performance | Near-native | More overhead |
| Best suited for | Microservices, CI/CD, cloud workloads | Full OS environments, legacy applications |

### Simple Example

A VM is like renting an entire house.

A container is like renting an isolated apartment inside a building.

Each apartment is isolated, but the building's basic infrastructure is shared.

---

# Docker Architecture

Docker follows a client-server architecture.

```text
                Docker Registry
               (Docker Hub etc.)
                      |
                      | pull / push
                      v
+---------------------+----------------------+
|                Docker Host                 |
|                                            |
|  Docker Client  --->  Docker Daemon        |
|    (docker CLI)          (dockerd)         |
|                              |             |
|                              v             |
|                         Docker Engine      |
|                              |             |
|                 +------------+-----------+ |
|                 |            |           | |
|              Image       Container    Network |
|                              |             |
|                              v             |
|                         Application       |
+--------------------------------------------+
```

## Docker Client

The Docker client is the command-line tool used to communicate with Docker.

Example:

```bash
docker ps
docker images
docker run nginx
```

## Docker Daemon

The Docker daemon (`dockerd`) runs in the background and is responsible for managing Docker objects such as:

- Images
- Containers
- Networks
- Volumes

## Docker Image

A Docker image is a read-only template used to create containers.

Examples:

```text
nginx
ubuntu
redis
mysql
```

An image contains the application and the dependencies required to run it.

## Docker Container

A container is a running instance of a Docker image.

For example:

```text
nginx image
     |
     v
Nginx container
```

One image can be used to create multiple containers.

## Docker Registry

A registry stores Docker images.

The most popular public registry is **Docker Hub**.

Example:

```bash
docker pull nginx
```

This downloads the Nginx image from a registry.

---

# Task 2 – Install Docker

Docker was installed on my machine using Docker Desktop.

## Verify Docker Installation

```bash
docker --version
```

Example output:

```text
Docker version ...
```

Another useful command:

```bash
docker info
```

This displays information about the Docker installation and Docker Engine.

---

# Run the Hello World Container

```bash
docker run hello-world
```

The `hello-world` image is a simple Docker image used to verify that Docker is working correctly.

### What happens when this command runs?

1. Docker checks whether the `hello-world` image exists locally.
2. If it does not exist, Docker pulls it from Docker Hub.
3. Docker creates a container from the image.
4. The container starts.
5. The program inside the container prints a message.
6. The container exits after completing its task.

This demonstrates the basic Docker workflow:

```text
Docker Client
     |
     v
Docker Daemon
     |
     v
Check local image
     |
     +---- Image missing ----> Pull from Registry
     |
     v
Create Container
     |
     v
Run Application
     |
     v
Container exits
```

---

# Task 3 – Run Real Containers

## 1. Run an Nginx Container

```bash
docker run -d -p 8080:80 --name my-nginx nginx
```

### Explanation

```text
-d
```

Runs the container in detached mode.

```text
-p 8080:80
```

Maps:

```text
Host Port 8080 → Container Port 80
```

```text
--name my-nginx
```

Gives the container a custom name.

```text
nginx
```

Specifies the Docker image to use.

After running the container, open:

```text
http://localhost:8080
```

The Nginx welcome page should appear.

---

## 2. Run an Ubuntu Container

```bash
docker run -it ubuntu
```

### Explanation

```text
-i
```

Keeps STDIN open.

```text
-t
```

Allocates a terminal.

Together:

```text
-it
```

allows interactive use of the container.

Once inside the Ubuntu container, commands such as these can be used:

```bash
cat /etc/os-release
pwd
ls
whoami
uname -a
```

Exit the container with:

```bash
exit
```

---

# 3. List Running Containers

```bash
docker ps
```

This displays currently running containers.

Example:

```text
CONTAINER ID   IMAGE   COMMAND   STATUS   PORTS   NAMES
```

---

# 4. List All Containers

```bash
docker ps -a
```

The `-a` option shows both:

- Running containers
- Stopped containers

---

# 5. Stop a Container

```bash
docker stop my-nginx
```

This gracefully stops the container.

---

# 6. Remove a Container

```bash
docker rm my-nginx
```

A stopped container can be removed using `docker rm`.

If the container is still running, stop it first:

```bash
docker stop my-nginx
docker rm my-nginx
```

---

# Task 4 – Explore Docker

## 1. Detached Mode

Run:

```bash
docker run -d nginx
```

The `-d` flag starts the container in the background.

Without detached mode, Docker attaches the terminal to the container's main process.

With detached mode:

```text
Terminal
   |
   +---- Docker Container
            |
            +---- Nginx running in background
```

Check it using:

```bash
docker ps
```

---

# 2. Give a Container a Custom Name

```bash
docker run -d --name web-server nginx
```

Instead of Docker automatically generating a name, the container will be called:

```text
web-server
```

This makes container management easier.

For example:

```bash
docker stop web-server
docker start web-server
docker logs web-server
```

---

# 3. Map a Port

```bash
docker run -d -p 8080:80 --name web-server nginx
```

Port mapping follows:

```text
-p HOST_PORT:CONTAINER_PORT
```

Therefore:

```text
-p 8080:80
```

means:

```text
localhost:8080
        |
        v
container:80
        |
        v
      Nginx
```

---

# 4. Check Container Logs

```bash
docker logs web-server
```

To continuously follow logs:

```bash
docker logs -f web-server
```

The `-f` option follows the container's output in real time.

---

# 5. Run a Command Inside a Running Container

```bash
docker exec -it web-server bash
```

This opens an interactive shell inside the running container.

For images that do not contain Bash, use:

```bash
docker exec -it web-server sh
```

Once inside:

```bash
ls
pwd
cat /etc/os-release
```

Exit with:

```bash
exit
```

---

# Important Docker Commands Learned

## Images

```bash
docker images
docker pull nginx
docker rmi nginx
```

## Containers

```bash
docker ps
docker ps -a
docker run nginx
docker start <container>
docker stop <container>
docker restart <container>
docker rm <container>
```

## Interactive Containers

```bash
docker run -it ubuntu
docker exec -it <container> bash
```

## Detached Containers

```bash
docker run -d nginx
```

## Port Mapping

```bash
docker run -d -p 8080:80 nginx
```

## Naming Containers

```bash
docker run -d --name my-container nginx
```

## Logs

```bash
docker logs <container>
docker logs -f <container>
```

## Container Inspection

```bash
docker inspect <container>
```

## Docker Information

```bash
docker --version
docker info
docker version
```

---

# Docker Command Cheat Sheet

| Command | Purpose |
|---|---|
| `docker --version` | Check Docker version |
| `docker info` | Show Docker Engine information |
| `docker images` | List local images |
| `docker pull <image>` | Download an image |
| `docker run <image>` | Create and run a container |
| `docker run -d <image>` | Run container in background |
| `docker run -it <image>` | Run interactively |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop <container>` | Stop a container |
| `docker start <container>` | Start a stopped container |
| `docker restart <container>` | Restart a container |
| `docker rm <container>` | Remove a container |
| `docker logs <container>` | View container logs |
| `docker exec -it <container> bash` | Open shell inside container |
| `docker inspect <container>` | Inspect container details |
| `docker rmi <image>` | Remove an image |

---

# What I Learned Today

Today I learned that Docker provides a lightweight way to package and run applications in isolated environments.

The most important concepts I learned were:

```text
Docker Image
     |
     v
Docker Container
     |
     v
Running Application
```

I also learned how Docker uses a client, daemon, images, containers, and registries to manage containerized applications.

The most important commands I practiced were:

```bash
docker run
docker ps
docker ps -a
docker stop
docker start
docker rm
docker logs
docker exec
docker pull
```

---

# Why Docker Matters for DevOps

Docker is one of the core technologies used in modern DevOps.

It is commonly used with:

- CI/CD pipelines
- Microservices
- Kubernetes
- Cloud platforms
- Application deployment
- Automated testing
- Infrastructure automation

Learning Docker is an important step toward working with technologies such as:

```text
Docker
   ↓
Docker Compose
   ↓
CI/CD
   ↓
Kubernetes
   ↓
Cloud
   ↓
Production DevOps
```

---

# Screenshots

The following screenshots should be added to this day's submission:

- Docker installation/version output
- `docker run hello-world`
- Running Nginx container
- Nginx welcome page in browser
- Ubuntu container in interactive mode
- `docker ps`
- `docker ps -a`
- Container logs
- `docker exec` session

---

# Submission

File location:

```text
2026/day-29/day-29-docker-basics.md
```

Then commit and push:

```bash
git add 2026/day-29/day-29-docker-basics.md
git commit -m "Add Day 29 Docker basics"
git push
```

---

## Day 29 Complete 🚀

Started with my first Docker container and learned the fundamentals of containerization.

**Next step: Go deeper into Docker images, Dockerfiles, volumes, networking, and Docker Compose.**

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
