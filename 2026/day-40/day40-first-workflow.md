# Day 40 – First GitHub Actions Workflow

## Objective

Create and run a first GitHub Actions workflow.

## Workflow

File:

```text
.github/workflows/hello.yml
```

Example:

```yaml
name: Hello GitHub Actions

on:
  push:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Say hello
        run: echo "Hello from GitHub Actions!"

      - name: Current date
        run: date

      - name: Branch
        run: echo "Branch: ${{ github.ref_name }}"

      - name: List files
        run: ls -la

      - name: Runner OS
        run: echo "OS: $RUNNER_OS"
```

## Workflow Anatomy

### `on`

Defines the event that starts the workflow.

```yaml
on:
  push:
```

### `jobs`

Defines the jobs executed by the workflow.

### `runs-on`

Selects the runner operating system.

```yaml
runs-on: ubuntu-latest
```

### `steps`

Contains the individual operations performed by a job.

### `uses`

Uses an existing GitHub Action.

```yaml
uses: actions/checkout@v4
```

### `run`

Executes a shell command.

```yaml
run: echo "Hello"
```

### Step `name`

Provides a human-readable name in the Actions UI.

## Failure Experiment

A deliberate failure can be produced with:

```yaml
- name: Intentional failure
  run: exit 1
```

The workflow becomes red and subsequent steps normally do not run.

After removing the failing command and pushing again, the workflow should return to green.


