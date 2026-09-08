# Day 45 – Docker Build & Push in GitHub Actions

## Objective

Automate Docker image building and publishing from GitHub Actions.

## Workflow

File:

```text
.github/workflows/docker-publish.yml
```

Example:

```yaml
name: Docker Publish

on:
  push:
    branches:
      - main

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            <DOCKERHUB_USERNAME>/<IMAGE_NAME>:latest
            <DOCKERHUB_USERNAME>/<IMAGE_NAME>:sha-${{ github.sha }}
```

## Required Secrets

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

The token should be stored in GitHub repository secrets, never directly in YAML.

## Main Branch Restriction

The workflow is triggered only by pushes to `main`.

For workflows that also build feature branches, the push operation can be guarded separately:

```yaml
if: github.ref == 'refs/heads/main'
```

## Image Tags

Two useful tags are:

```text
latest
sha-<commit>
```

`latest` is convenient for the current release, while a commit-based tag provides an immutable reference to a specific build.

## Docker Hub

Repository:

```text
<ADD DOCKER HUB URL>
```

## Full Journey

```text
git push
   |
   v
GitHub Actions
   |
   v
Checkout source
   |
   v
Authenticate to Docker Hub
   |
   v
Build Docker image
   |
   v
Tag image
   |
   v
Push image
   |
   v
Docker Hub
   |
   v
docker pull
   |
   v
Running container
```
