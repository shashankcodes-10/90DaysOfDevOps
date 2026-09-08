# Day 46 – Reusable Workflows & Composite Actions

## Reusable Workflow

A reusable workflow is a workflow that another workflow can call instead of duplicating the same jobs and steps.

It is enabled with:

```yaml
on:
  workflow_call:
```

Reusable workflows live in:

```text
.github/workflows/
```

## `reusable-build.yml`

```yaml
name: Reusable Build

on:
  workflow_call:
    inputs:
      app_name:
        required: true
        type: string
      environment:
        required: true
        type: string
        default: staging
    secrets:
      docker_token:
        required: true
    outputs:
      build_version:
        description: Generated build version
        value: ${{ jobs.build.outputs.build_version }}

jobs:
  build:
    runs-on: ubuntu-latest

    outputs:
      build_version: ${{ steps.version.outputs.build_version }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build
        run: echo "Building ${{ inputs.app_name }} for ${{ inputs.environment }}"

      - name: Check secret
        env:
          TOKEN: ${{ secrets.docker_token }}
        run: |
          if [ -n "$TOKEN" ]; then
            echo "Docker token is set: true"
          else
            echo "Docker token is set: false"
            exit 1
          fi

      - name: Generate version
        id: version
        run: echo "build_version=v1.0-${GITHUB_SHA::7}" >> "$GITHUB_OUTPUT"
```

## Caller Workflow

```yaml
name: Call Reusable Build

on:
  push:
    branches:
      - main

jobs:
  build:
    uses: ./.github/workflows/reusable-build.yml
    with:
      app_name: my-web-app
      environment: production
    secrets:
      docker_token: ${{ secrets.DOCKER_TOKEN }}

  show-version:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build version: ${{ needs.build.outputs.build_version }}"
```

## Composite Action

Path:

```text
.github/actions/setup-and-greet/action.yml
```

Example:

```yaml
name: Setup and Greet
description: Print a greeting and runner information

inputs:
  name:
    description: Name to greet
    required: true
  language:
    description: Greeting language
    required: false
    default: en

outputs:
  greeted:
    description: Whether greeting was completed
    value: true

runs:
  using: composite
  steps:
    - name: Greeting
      shell: bash
      run: |
        case "${{ inputs.language }}" in
          hi)
            echo "Namaste, ${{ inputs.name }}!"
            ;;
          es)
            echo "Hola, ${{ inputs.name }}!"
            ;;
          *)
            echo "Hello, ${{ inputs.name }}!"
            ;;
        esac

    - name: Runner information
      shell: bash
      run: |
        date
        echo "OS: $RUNNER_OS"
```

## Reusable Workflow vs Composite Action

| | Reusable Workflow | Composite Action |
|---|---|---|
| Triggered by | `workflow_call` | `uses:` in a step |
| Can contain jobs? | Yes | No |
| Can contain multiple steps? | Yes | Yes |
| Lives where? | `.github/workflows/` | Action directory with `action.yml` |
| Can accept secrets directly? | Yes | Secrets can be passed through environment/inputs |
| Best for | Reusing complete job/workflow logic | Reusing a group of steps |

## Key Learning

Reusable workflows reduce duplication at the job/workflow level. Composite actions reduce duplication at the step level.
