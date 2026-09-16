## GitHub Actions Status Badges

[![PR Pipeline](https://github.com/shashankcodes-10/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg)](https://github.com/shashankcodes-10/github-actions-capstone/actions/workflows/pr-pipeline.yml)
[![Main Pipeline](https://github.com/shashankcodes-10/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg)](https://github.com/shashankcodes-10/github-actions-capstone/actions/workflows/main-pipeline.yml)
[![Health Check](https://github.com/shashankcodes-10/github-actions-capstone/actions/workflows/health-check.yml/badge.svg)](https://github.com/shashankcodes-10/github-actions-capstone/actions/workflows/health-check.yml)

# GitHub Actions Capstone

An end-to-end GitHub Actions CI/CD project using Flask, Docker, reusable workflows, Docker Hub, production deployment, scheduled health checks, and Trivy security scanning.

## Pipeline

```text
Pull Request
    ↓
Build & Test
    ↓
PR Checks

Merge to main
    ↓
Build & Test
    ↓
Docker Build & Push
    ↓
Trivy Image Scan
    ↓
Production Deploy

Every 12 hours
    ↓
Pull Latest Image
    ↓
Run Container
    ↓
Health Check
```

## Local Run

```bash
pip install -r requirements.txt
python -m app.main
```

Health endpoint:

```bash
curl http://localhost:5000/health
```

## Test

```bash
pytest -q
```

## Docker

```bash
docker build -t github-actions-capstone:latest .
docker run -d --name github-actions-capstone -p 5000:5000 github-actions-capstone:latest
curl http://localhost:5000/health
docker rm -f github-actions-capstone
```

## GitHub Actions

The repository uses reusable workflows for build/test and Docker publishing. PRs run tests only. Pushes to `main` run the full CI/CD flow.

### Required repository secrets

- `DOCKER_USERNAME`
- `DOCKER_TOKEN`

### Production environment

Create a GitHub environment named `production`. Required reviewers can be configured in repository settings.

## Workflow badges

Replace `YOUR_GITHUB_USERNAME` and `github-actions-capstone` with your repository values.

![PR Pipeline](https://github.com/YOUR_GITHUB_USERNAME/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg)
![Main Pipeline](https://github.com/YOUR_GITHUB_USERNAME/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg)
![Health Check](https://github.com/YOUR_GITHUB_USERNAME/github-actions-capstone/actions/workflows/health-check.yml/badge.svg)
