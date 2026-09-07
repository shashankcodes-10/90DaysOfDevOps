# Docker Cheat Sheet

## Containers

| Command | Purpose |
|---|---|
| `docker run IMAGE` | Create and start a container |
| `docker run -d IMAGE` | Run in detached mode |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop CONTAINER` | Stop a container |
| `docker start CONTAINER` | Start a stopped container |
| `docker restart CONTAINER` | Restart a container |
| `docker rm CONTAINER` | Remove a container |
| `docker exec -it CONTAINER sh` | Open a shell |
| `docker logs CONTAINER` | View logs |
| `docker inspect CONTAINER` | Inspect configuration |

## Images

| Command | Purpose |
|---|---|
| `docker images` | List images |
| `docker pull IMAGE` | Download an image |
| `docker build -t NAME:TAG .` | Build an image |
| `docker tag IMAGE USER/REPO:TAG` | Tag an image |
| `docker push USER/REPO:TAG` | Push an image |
| `docker rmi IMAGE` | Remove an image |

## Volumes

| Command | Purpose |
|---|---|
| `docker volume create NAME` | Create a volume |
| `docker volume ls` | List volumes |
| `docker volume inspect NAME` | Inspect a volume |
| `docker volume rm NAME` | Remove a volume |

## Networks

| Command | Purpose |
|---|---|
| `docker network create NAME` | Create a network |
| `docker network ls` | List networks |
| `docker network inspect NAME` | Inspect a network |
| `docker network connect NET CONTAINER` | Connect a container |

## Docker Compose

| Command | Purpose |
|---|---|
| `docker compose up -d` | Start services |
| `docker compose down` | Stop and remove services |
| `docker compose ps` | Show service status |
| `docker compose logs -f` | Follow logs |
| `docker compose build` | Build services |
| `docker compose up -d --build` | Build and start |

## Cleanup

```bash
docker system df
docker image prune
docker container prune
docker volume prune
docker network prune
docker system prune
```

Use prune commands carefully because they remove unused Docker resources.

## Dockerfile Instructions

| Instruction | Purpose |
|---|---|
| `FROM` | Select base image |
| `RUN` | Execute build-time command |
| `COPY` | Copy files into image |
| `WORKDIR` | Set working directory |
| `EXPOSE` | Document intended container port |
| `CMD` | Default command |
| `ENTRYPOINT` | Main executable/entrypoint |

## Important Concepts

- An image is an immutable template.
- A container is a running instance of an image.
- Container filesystem data disappears when the container is removed unless stored externally.
- Containers on the same user-defined network can communicate using container/service names.
- Multi-stage builds keep build dependencies out of the final runtime image.
