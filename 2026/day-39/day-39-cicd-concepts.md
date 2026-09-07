# Day 39 – CI/CD Concepts

## Why CI/CD Exists

When software delivery is handled manually, common problems include:

- Human error
- Inconsistent environments
- Broken builds reaching later stages
- Slow feedback
- Deployment bottlenecks
- Difficult rollbacks
- The classic "it works on my machine" problem

CI/CD automates repeatable parts of software delivery and provides faster feedback.

## Continuous Integration

Continuous Integration means developers frequently integrate changes into a shared repository and automatically build and test those changes.

**Example:** A push or pull request can start a workflow that checks out the code, installs dependencies, runs tests, and reports the result.

## Continuous Delivery

Continuous Delivery keeps the application in a deployable state. The pipeline automatically builds and prepares the release, while production deployment may still require approval.

**Example:** A successful build creates a release artifact and waits for production approval.

## Continuous Deployment

Continuous Deployment goes one step further. Changes that pass the required automated checks are automatically deployed to production.

**Example:** A successful main-branch pipeline automatically deploys the new application version.

## Pipeline Anatomy

| Component | Purpose |
|---|---|
| Trigger | Event that starts a workflow |
| Stage | Logical phase such as build, test, or deploy |
| Job | Unit of work executed by a runner |
| Step | Individual command or action |
| Runner | Machine executing the job |
| Artifact | Output produced by a job |

## Example Pipeline

```text
Developer
   |
   v
Git Push
   |
   v
Checkout
   |
   v
Test
   |
   v
Build Docker Image
   |
   v
Deploy to Staging
```

## Open-Source Workflow Review

**Repository:**  
TrainWithShubham/github-actions-zero-to-hero

**Workflow:**  
`.github/workflows/cicd.yml`

The repository contains a Flask application with GitHub Actions workflows covering CI/CD and DevSecOps concepts.

### Observations

- **Trigger:** `workflow_dispatch`
- **Input:** `environment` with `dev`, `prod`, and `staging` choices
- **Jobs:** `code`, `build`, `test`, and `deploy`
- **Runner:** `ubuntu-latest`
- **Job dependencies:** `build` needs `code`; `test` needs `build`; `deploy` needs both `build` and `test`
- **Condition:** `deploy` runs only when `inputs.environment == 'dev'`
- **Main purpose:** Demonstrates a basic CI/CD pipeline with job dependencies, manual inputs, and conditional deployment.

### Workflow Flow

```text
Manual Workflow Trigger
        |
        v
      Code
        |
        v
      Build
        |
        v
       Test
        |
        v
 Deploy (dev only)
```

## Key Learning

CI/CD is a software delivery practice. GitHub Actions, Jenkins, GitLab CI, and similar platforms are tools used to implement automated pipelines.

The reviewed workflow demonstrates how GitHub Actions can connect separate jobs using `needs` and control deployment using workflow inputs and `if` conditions.

## Repository

https://github.com/TrainWithShubham/github-actions-zero-to-hero
