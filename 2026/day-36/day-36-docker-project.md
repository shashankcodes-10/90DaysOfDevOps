
# Day 36 – Docker Project: Dockerize a Full Application

## Project Overview

For Day 36, I Dockerized my existing **Flask + MySQL two-tier application** using Docker and Docker Compose.

The application allows users to submit messages through the Flask application, which stores the messages in MySQL and displays them.

### Tech Stack

- Python / Flask
- MySQL
- Docker
- Docker Compose

---

## Architecture

```text
              User
                |
                | :5001
                v
       +------------------+
       |    Flask App     |
       |  two-tier-flask  |
       +--------+---------+
                |
                | MySQL :3306
                v
       +------------------+
       |      MySQL       |
       |      mysql       |
       +--------+---------+
                |
                v
          mysql-data
            Volume
```

---

## Dockerfile

I used a multi-stage Dockerfile to separate build dependencies from runtime dependencies.

```dockerfile
# ---------------- Builder ----------------

FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir \
    --prefix=/app/deps \
    -r requirements.txt


# ---------------- Runner ----------------

FROM python:3.12-slim AS runner

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libmariadb3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/deps /usr/local

COPY . .

RUN useradd -m appuser && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
```

### Dockerfile Observations

- Multi-stage build
- Slim base image
- Build dependencies separated from runtime dependencies
- Non-root application user
- Pip cache disabled

---

## .dockerignore

```text
__pycache__
*.pyc
.venv
venv
.env
.git
*.log
```

---

## Docker Compose

Docker Compose runs the Flask application and MySQL database together.

```yaml
services:

  flask-app:

    container_name: two-tier-flask

    build: .

    ports:
      - "5001:5000"

    networks:
      - flask-app

    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_DB: ${MYSQL_DATABASE}

    depends_on:
      mysql:
        condition: service_healthy

    healthcheck:
      test:
        [
          "CMD",
          "python",
          "-c",
          "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"
        ]
      interval: 10s
      timeout: 5s
      retries: 5


  mysql:

    container_name: mysql

    image: mysql:5.7

    platform: linux/amd64

    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_ROOT_PASSWORD: ${MYSQL_PASSWORD}

    volumes:
      - mysql-data:/var/lib/mysql

    networks:
      - flask-app

    healthcheck:
      test:
        [
          "CMD",
          "mysqladmin",
          "ping",
          "-h",
          "localhost",
          "-u",
          "root",
          "-p${MYSQL_PASSWORD}"
        ]
      interval: 10s
      timeout: 5s
      retries: 5


networks:

  flask-app:


volumes:

  mysql-data:
```

---

## Environment Variables

```env
MYSQL_DATABASE=mydb
MYSQL_PASSWORD=admin
```

The `.env` file is excluded from Git.

---

## Running the Application

```bash
docker compose up --build -d
docker compose ps
```

Expected:

```text
mysql           Up (healthy)
two-tier-flask  Up (healthy)
```

Application:

```text
http://localhost:5001
```

Health check:

```bash
curl http://localhost:5001/health
```

Expected:

```json
{"status":"healthy"}
```

---

## Docker Hub

Build and push the image:

```bash
docker build -t flaskapp .
docker tag flaskapp:latest shashankcodes10/flaskapp:latest
docker push shashankcodes10/flaskapp:latest
```

Docker Hub:

https://hub.docker.com/r/shashankcodes10/flaskapp

---

## Fresh Deployment Test

```bash
docker compose down
docker image rm flaskapp:latest
docker pull shashankcodes10/flaskapp:latest
docker compose up -d
docker compose ps
curl http://localhost:5001/health
```

---

## Observations

- Flask and MySQL ran successfully as separate containers.
- Both containers became healthy.
- Flask connected to MySQL using the Docker service name `mysql`.
- MySQL data persisted through the `mysql-data` volume.
- Both services communicated through the custom Docker network.
- Port `5001` mapped to Flask container port `5000`.
- The `/health` endpoint returned a healthy response.
- The application ran as a non-root user.
- Multi-stage build kept build dependencies out of the runtime image.
- The application was tested using the Docker Hub image.

---

## Challenges & Solutions

### MySQL Startup

**Solution:** Added a MySQL healthcheck and used `depends_on` with `service_healthy`.

### mysqlclient Dependencies

**Solution:** Installed build dependencies only in the builder stage and runtime libraries in the final stage.

### Database Persistence

**Solution:** Used the `mysql-data` named volume.

### Container Communication

**Solution:** Used `MYSQL_HOST=mysql` because Docker Compose resolves the service name automatically.

---

## Final Image Size

The final image size was checked using:

```bash
docker images flaskapp
```

---

## Conclusion

Successfully Dockerized and tested a complete Flask + MySQL application using Docker and Docker Compose.
