# Day 49 – DevSecOps: Add Security to Your CI/CD Pipeline

## Overview

Today I added security checks to the GitHub Actions CI/CD pipeline from Day 48. The pipeline now checks Docker images for vulnerabilities, reviews new dependencies in pull requests, and uses restricted workflow permissions.

DevSecOps means making security part of the normal development and CI/CD process instead of treating it as a separate step after deployment. Automated checks help identify security issues earlier and make security checks repeatable.

## Pipeline Architecture

```text
PR opened
   ↓
Build & Test
   ↓
Dependency Review
   ↓
PR checks pass

Merge to main
   ↓
Build & Test
   ↓
Docker Build & Push
   ↓
Trivy Image Scan
   ↓
Deploy to production

Always active
   ├── Secret Scanning
   └── Push Protection

Every 12 hours / manual
   ↓
Health Check
```

## Trivy Docker Image Scan

The main branch pipeline now runs Trivy against the Docker image before the production deployment job.

```yaml
- name: Scan Docker Image for Vulnerabilities
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: '${{ needs.docker.outputs.image_url }}'
    format: 'table'
    exit-code: '1'
    severity: 'CRITICAL,HIGH'
    ignore-unfixed: true
```

`exit-code: '1'` makes the security job fail when matching vulnerabilities are found. The scan checks HIGH and CRITICAL severity vulnerabilities. Unfixed vulnerabilities are ignored with `ignore-unfixed: true`.

A SARIF report is also generated and uploaded as a GitHub Actions artifact for later inspection.

## Secret Scanning and Push Protection

GitHub Secret Scanning can detect credentials and other sensitive values that may have been committed to the repository.

Push protection works earlier by blocking a push when GitHub identifies a supported secret before it becomes part of the repository history.

If a supported AWS access key is detected, push protection can block the push. If a secret has already been exposed, the credential should be revoked or rotated immediately. Removing the value from the latest commit alone does not make an exposed credential safe.

## Dependency Review

The PR pipeline now uses GitHub's dependency review action:

```yaml
- name: Check dependencies for vulnerabilities
  uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: critical
```

Dependency review checks dependency changes introduced by a pull request. With `fail-on-severity: critical`, a critical vulnerability in the dependency changes can fail the check.

## Workflow Permissions

The workflows use the minimum required repository permission:

```yaml
permissions:
  contents: read
```

This follows the principle of least privilege. A workflow should receive only the permissions required for its job.

If a third-party action or compromised step had unnecessary write permissions, an attacker could potentially modify repository content, change workflow files, or perform other actions allowed by the token. Restricting permissions reduces the possible impact.

## Updated Workflow Flow

### Pull Request

```text
PR opened
    ↓
Build & Test
    ↓
Dependency Review
    ↓
PR checks
```

The PR pipeline does not build or push a Docker image.

### Main Branch

```text
Push to main
    ↓
Build & Test
    ↓
Docker Build & Push
    ↓
Trivy Scan
    ↓
Production Deploy
```

The deploy job depends on the Trivy security job, so a failed security scan prevents deployment.

### Repository Security

```text
Secret Scanning
       +
Push Protection
```

These protections operate independently of the normal build and deployment workflow.

## Workflow Files Updated

```text
.github/workflows/
├── reusable-build-test.yml
├── reusable-docker.yml
├── pr-pipeline.yml
├── main-pipeline.yml
└── health-check.yml
```

## What I Learned

- DevSecOps integrates security checks into the CI/CD workflow.
- Trivy scans Docker images for known vulnerabilities.
- A pipeline can fail automatically when HIGH or CRITICAL vulnerabilities are detected.
- Secret scanning detects credentials that may have been committed to a repository.
- Push protection can stop supported secrets from being pushed.
- Dependency review checks dependency changes in pull requests.
- Workflow permissions should follow the principle of least privilege.
- Security checks should be automated instead of relying only on manual review.

## What I Would Add Next

- Pin third-party GitHub Actions to commit SHAs.
- Upload SARIF results to the GitHub Security tab.
- Add Slack or email security notifications.
- Use GitHub Actions OIDC for short-lived cloud authentication.
- Add separate development, staging, and production environments.
- Add an automated rollback strategy for failed deployments.
