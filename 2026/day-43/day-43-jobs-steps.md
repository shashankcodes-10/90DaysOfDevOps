# Day 43 – Jobs, Steps, Environment Variables & Conditionals

## Multi-Job Workflow

```yaml
name: Multi Job

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building the app"

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Running tests"

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying"
```

The dependency chain is:

```text
build → test → deploy
```

## Environment Variables

Workflow level:

```yaml
env:
  APP_NAME: myapp
```

Job level:

```yaml
env:
  ENVIRONMENT: staging
```

Step level:

```yaml
env:
  VERSION: 1.0.0
```

Example:

```yaml
- name: Print environment
  env:
    VERSION: 1.0.0
  run: |
    echo "$APP_NAME"
    echo "$ENVIRONMENT"
    echo "$VERSION"
    echo "${{ github.sha }}"
    echo "${{ github.actor }}"
```

## Job Outputs

A job can generate a value and expose it to dependent jobs.

```yaml
jobs:
  version:
    runs-on: ubuntu-latest
    outputs:
      build_version: ${{ steps.version.outputs.build_version }}
    steps:
      - id: version
        run: echo "build_version=v1.0-${GITHUB_SHA::7}" >> "$GITHUB_OUTPUT"

  deploy:
    needs: version
    runs-on: ubuntu-latest
    steps:
      - run: echo "Version: ${{ needs.version.outputs.build_version }}"
```

Outputs are useful for passing generated values between independent jobs.

## Conditionals

Only on main:

```yaml
if: github.ref == 'refs/heads/main'
```

Run after a previous step fails:

```yaml
if: failure()
```

A push-only workflow can use:

```yaml
on:
  push:
```

## Key Learning

Jobs are isolated execution units. `needs` controls job dependencies, outputs transfer values between jobs, environment variables provide configuration, and `if` controls conditional execution.
