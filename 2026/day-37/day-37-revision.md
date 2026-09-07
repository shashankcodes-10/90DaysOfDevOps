# Day 37 – Docker Revision

## Self-Assessment

| Skill | Status |
|---|---|
| Run interactive and detached containers | Can do |
| List, stop and remove containers | Can do |
| Explain image layers and caching | Can do |
| Write a Dockerfile | Can do |
| Explain CMD vs ENTRYPOINT | Can do |
| Build and tag images | Can do |
| Use named volumes | Can do |
| Use bind mounts | Can do |
| Create custom networks | Can do |
| Write Compose files | Can do |
| Use `.env` with Compose | Can do |
| Write multi-stage Dockerfiles | Can do |
| Push images to Docker Hub | Can do |
| Use healthchecks and `depends_on` | Can do |

## Quick-Fire Questions

### 1. Image vs Container

An image is a packaged, immutable template. A container is an instance created from that image with its own runtime state.

### 2. What happens to container data?

Data stored only in the writable container layer is lost when the container is removed. Volumes and bind mounts persist independently.

### 3. Container communication

Containers connected to the same user-defined network can communicate using container/service names through Docker's internal DNS.

### 4. `docker compose down -v`

`docker compose down` removes the containers and networks created by Compose. Adding `-v` also removes the named and anonymous volumes declared by the Compose project.

### 5. Multi-stage builds

They separate build dependencies from runtime dependencies, producing smaller and cleaner production images.

### 6. COPY vs ADD

`COPY` is the straightforward file-copy instruction and is preferred for normal file copying. `ADD` has additional behavior such as archive extraction and URL support.

### 7. `-p 8080:80`

It maps host port `8080` to container port `80`.

### 8. Check Docker disk usage

```bash
docker system df
```

## Weak Areas Revisited

Two areas to revisit regularly:

1. Docker networking
2. Multi-stage builds

Hands-on practice is more valuable than memorizing commands.
