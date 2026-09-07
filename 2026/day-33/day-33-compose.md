# Day 33 – Docker Compose: Multi-Container Basics

## Objective

The goal of Day 33 was to understand Docker Compose and use a single YAML file to manage multiple containers, networks, volumes, and environment variables.

## Task 1 – Install & Verify Docker Compose

Docker Compose is available through the modern Docker CLI.

```bash
docker compose version
```

Example:

```text
Docker Compose version v2.4.1
```

## Task 2 – First Compose File

Created `compose-basics/docker-compose.yml` to run an Nginx container.

Example:

```yaml
services:
  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
```

Start:

```bash
docker compose up -d
```

Verify:

```bash
docker compose ps
```

Open:

```text
http://localhost:8080
```

Stop and remove:

```bash
docker compose down
```

## Task 3 – WordPress + MySQL

Created a two-container application consisting of:

- WordPress
- MySQL
- Named MySQL volume
- Compose-managed network

Important point: WordPress connects to MySQL using the Compose service name rather than an IP address.

Example connection setting:

```yaml
WORDPRESS_DB_HOST: db:3306
```

The database uses a named volume so its data survives container removal.

## Task 4 – Useful Compose Commands

| Command | Purpose |
|---|---|
| `docker compose up -d` | Start services in detached mode |
| `docker compose ps` | Show service status |
| `docker compose logs -f` | Follow logs |
| `docker compose logs -f db` | Follow one service |
| `docker compose stop` | Stop services without removing them |
| `docker compose down` | Remove containers and network |
| `docker compose up -d --build` | Rebuild and start |

## Task 5 – Environment Variables

Compose supports variables directly in YAML and through a `.env` file.

Example `.env`:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=change-me
MYSQL_ROOT_PASSWORD=change-me
```

Reference:

```yaml
environment:
  MYSQL_DATABASE: ${MYSQL_DATABASE}
  MYSQL_USER: ${MYSQL_USER}
  MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

> Do not commit real passwords or secrets. Use `.env.example` for public repositories.

## Key Learnings

1. Compose allows multiple containers to be defined declaratively.
2. Compose services can communicate using service names as DNS names.
3. Named volumes provide persistence independently of container lifecycle.
4. `.env` files make configuration easier to manage.


