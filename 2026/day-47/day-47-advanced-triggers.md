# Day 47 – Advanced GitHub Actions Triggers

## PR Lifecycle Events

```yaml
name: PR Lifecycle

on:
  pull_request:
    types: [opened, synchronize, reopened, closed]

jobs:
  lifecycle:
    runs-on: ubuntu-latest
    steps:
      - name: Event details
        run: |
          echo "Event: ${{ github.event.action }}"
          echo "Title: ${{ github.event.pull_request.title }}"
          echo "Author: ${{ github.event.pull_request.user.login }}"
          echo "Source: ${{ github.head_ref }}"
          echo "Target: ${{ github.base_ref }}"

      - name: Merged PR
        if: github.event.action == 'closed' && github.event.pull_request.merged == true
        run: echo "Pull request was merged."
```

## PR Validation

A production-style PR gate can validate:

- File sizes.
- Branch naming.
- PR description.

Example file-size check:

```bash
if find . -type f -not -path './.git/*' -size +1M | grep -q .; then
  echo "A file larger than 1 MB was found."
  exit 1
fi
```

Branch convention:

```text
feature/*
fix/*
docs/*
```

## Cron Schedules

Monday at 2:30 AM UTC:

```text
30 2 * * 1
```

Every 6 hours:

```text
0 */6 * * *
```

Every weekday at 9 AM IST:

```text
30 3 * * 1-5
```

IST is UTC+5:30, so 09:00 IST equals 03:30 UTC.

First day of every month at midnight UTC:

```text
0 0 1 * *
```

Scheduled workflows run from the default branch and may be delayed during periods of high GitHub Actions load or other GitHub scheduling constraints.

## Path Filters

Only changes under `src/` or `app/`:

```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'app/**'
```

Ignore documentation-only changes:

```yaml
on:
  push:
    paths-ignore:
      - '*.md'
      - 'docs/**'
```

Use `paths` when you want to define what should trigger a workflow. Use `paths-ignore` when you want to exclude specific paths.

## `workflow_run`

A test workflow can trigger first:

```yaml
name: Run Tests

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Running tests"
```

A second workflow can wait for it:

```yaml
name: Deploy After Tests

on:
  workflow_run:
    workflows: ["Run Tests"]
    types: [completed]

jobs:
  deploy:
    if: github.event.workflow_run.conclusion == 'success'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying after successful tests"
```

`workflow_run` connects separate workflow executions.

## `workflow_run` vs `workflow_call`

| | `workflow_run` | `workflow_call` |
|---|---|---|
| Purpose | React to another workflow run | Explicitly call a reusable workflow |
| Trigger type | Event | Workflow trigger |
| Typical use | Test → deploy chaining | Shared CI/CD logic |
| Inputs | Event information | Explicit inputs/secrets |
| Execution relationship | Separate workflow runs | Caller invokes reusable workflow |

## `repository_dispatch`

Example:

```yaml
name: External Trigger

on:
  repository_dispatch:
    types: [deploy-request]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Environment
        run: echo "Environment: ${{ github.event.client_payload.environment }}"
```

Example GitHub CLI trigger:

```bash
gh api repos/<owner>/<repo>/dispatches \
  -f event_type=deploy-request \
  -f client_payload='{"environment":"production"}'
```

An external system such as a deployment platform, monitoring service, bot, or internal automation service can use this mechanism to request a workflow.

## Key Learnings

- PR event types allow workflows to react to specific lifecycle events.
- Cron schedules automate periodic jobs.
- Path and branch filters reduce unnecessary workflow runs.
- `workflow_run` chains independent workflows.
- `workflow_call` is for explicitly reusing workflow logic.
- `repository_dispatch` allows external systems to trigger workflows.
