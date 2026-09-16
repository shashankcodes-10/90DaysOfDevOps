# Day 48 – GitHub Actions Project: End-to-End CI/CD Pipeline

## Project

This project combines GitHub Actions concepts from Days 40–47 into an end-to-end CI/CD pipeline.

The application is a small Flask API with a `/health` endpoint. The application is containerized with Docker and automated through reusable GitHub Actions workflows.

## Pipeline Architecture

```text
PR opened / synchronized
        |
        v
Reusable Build & Test
        |
        v
PR Checks Summary

Merge / Push to main
        |
        v
Reusable Build & Test
        |
        v
Reusable Docker Build & Push
        |
        v
Production Deploy
        |
        v
GitHub Environment: production

Every 12 hours / Manual Run
        |
        v
Pull latest Docker image
        |
        v
Run container
        |
        v
Curl /health
        |
        v
Health Check Summary
```

## Project Structure

```text
github-actions-capstone/
├── .github/
│   └── workflows/
│       ├── reusable-build-test.yml
│       ├── reusable-docker.yml
│       ├── pr-pipeline.yml
│       ├── main-pipeline.yml
│       └── health-check.yml
├── app/
│   └── main.py
├── tests/
│   └── test_app.py
├── Dockerfile
├── .dockerignore
├── requirements.txt
├── README.md
└── day-48-actions-project.md
```

## Workflows

### 1. Reusable Build & Test

`reusable-build-test.yml` is triggered through `workflow_call`.

It:
- Checks out the repository.
- Sets up Python.
- Installs dependencies.
- Runs pytest when `run_tests` is enabled.
- Exposes a `test_result` output.

### 2. Reusable Docker Build & Push

`reusable-docker.yml` is triggered through `workflow_call`.

It:
- Checks out the code.
- Logs into Docker Hub using GitHub secrets.
- Builds the Docker image.
- Pushes the requested tag.
- Exposes the full image path as `image_url`.

### 3. PR Pipeline

`pr-pipeline.yml` runs for opened and synchronized pull requests targeting `main`.

It calls only the reusable build/test workflow and then prints a PR checks summary. Docker images are not built or pushed by this workflow.

### 4. Main Pipeline

`main-pipeline.yml` runs when code is pushed to `main`.

The jobs execute in this order:

```text
build-test → docker → deploy
```

The Docker job publishes the `latest` image. The deploy job consumes the reusable workflow output and runs against the `production` environment.

### 5. Scheduled Health Check

`health-check.yml` runs every 12 hours and can also be started manually.

It:
- Pulls the latest Docker image.
- Starts the container.
- Waits five seconds.
- Calls `/health`.
- Writes a GitHub Actions summary.
- Removes the container.

## Configuration

Create these repository secrets:

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

Create this repository variable:

```text
DOCKER_IMAGE
```

Example value:

```text
your-dockerhub-username/github-actions-capstone
```

Create a GitHub environment named:

```text
production
```

Required reviewers can be configured as environment protection rules.

## Docker Image

Docker Hub image:

```text
https://hub.docker.com/r/YOUR_DOCKERHUB_USERNAME/github-actions-capstone
```

Replace `YOUR_DOCKERHUB_USERNAME` with the Docker Hub username used for the project.

## Security

The project structure is ready for the Day 48 security extension. A Trivy image scan can be added after the Docker build/push stage and configured to fail on CRITICAL vulnerabilities.

## What I Would Improve Next

- Add Trivy vulnerability scanning to the main pipeline.
- Add multi-environment deployment for staging and production.
- Add Slack or email notifications.
- Add deployment rollback handling.
- Add Kubernetes deployment instead of the current deployment placeholder.
- Add image tagging based on commit SHA.
- Add branch protection and required status checks.
