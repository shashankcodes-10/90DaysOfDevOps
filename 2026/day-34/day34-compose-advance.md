# Day 34 – Docker Compose: Real-World Multi-Container Apps

## Objective

Build a production-style three-service application using Docker Compose:

```text
Web Application
      |
      +---- PostgreSQL
      |
      +---- Redis
```

## Stack

- Application: Python Flask
- Database: PostgreSQL
- Cache: Redis
- Orchestration: Docker Compose

## Application Dockerfile

The application is built from a Dockerfile instead of relying only on a pre-built image.

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

## Healthcheck

PostgreSQL is checked using `pg_isready`.

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 10s
  timeout: 5s
  retries: 5
```

The application waits for the database to become healthy:

```yaml
depends_on:
  db:
    condition: service_healthy
```

This is better than assuming that a started container means the database is ready to accept connections.

## Restart Policies

### `restart: always`

The service is restarted whenever it stops, including after Docker restarts.

### `restart: on-failure`

The service is restarted when its process exits with a failure status.

For long-running infrastructure services, `always` can be useful. `on-failure` is useful when a service should restart only after an abnormal process failure.

## Custom Network and Volume

A named network keeps the application stack isolated and a named volume persists PostgreSQL data.

```yaml
networks:
  app-network:

volumes:
  postgres-data:
```

## Rebuild

After changing application code:

```bash
docker compose up -d --build
```

## Scaling Experiment

Attempted scaling with:

```bash
docker compose up -d --scale web=3
```

When the same host port is published by every replica, Docker cannot bind the same host port multiple times. A reverse proxy/load balancer or different port strategy is required for practical scaling.

## Key Learnings

- Healthchecks measure service readiness.
- `depends_on` can use health status conditions.
- Restart policies improve resilience.
- Named networks and volumes make Compose stacks easier to manage.
- Scaling application replicas requires a sensible networking/load-balancing strategy.
