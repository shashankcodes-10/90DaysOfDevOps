# Day 35 – Multi-Stage Builds & Docker Hub

## Objective

Compare a traditional single-stage Docker build with a multi-stage build and publish the optimized image to Docker Hub.

## Application

A simple application was used to demonstrate the image-building process.

## Single-Stage Build

A single-stage Dockerfile contains both the build environment and runtime environment.

This can make the final image larger because compilers, package managers, source code, and build dependencies remain in the image.

Check image size:

```bash
docker images
```

Record the result:

```text
Single-stage image size: <ADD SIZE>
```

## Multi-Stage Build

A multi-stage Dockerfile separates building from running:

```dockerfile
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:1-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
```

The runtime image contains only what is required to run the application.

Record:

```text
Multi-stage image size: <ADD SIZE>
```

## Comparison

| Build | Size |
|---|---:|
| Single-stage | `<SIZE>` |
| Multi-stage | `<SIZE>` |

The multi-stage image is smaller because build-time dependencies and source files are not copied into the final runtime image.

## Docker Hub

Authenticate:

```bash
docker login
```

Tag:

```bash
docker tag my-app:latest <DOCKERHUB_USERNAME>/my-app:latest
```

Push:

```bash
docker push <DOCKERHUB_USERNAME>/my-app:latest
```

Pull:

```bash
docker pull <DOCKERHUB_USERNAME>/my-app:latest
```

Docker Hub repository:

```text
<ADD DOCKER HUB URL>
```

## Image Best Practices

- Use a minimal base image.
- Use a specific base-image tag.
- Avoid running applications as root.
- Keep build dependencies out of the runtime image.
- Reduce unnecessary layers and files.

