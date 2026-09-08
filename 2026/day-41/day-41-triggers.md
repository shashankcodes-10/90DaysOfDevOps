# Day 41 – Triggers & Matrix Builds

## Pull Request Trigger

Example:

```yaml
name: PR Check

on:
  pull_request:
    types: [opened, synchronize]
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - run: echo "PR check running for branch: ${{ github.head_ref }}"
```

This workflow runs when a PR is opened or updated against `main`.

## Scheduled Trigger

Every day at midnight UTC:

```yaml
on:
  schedule:
    - cron: '0 0 * * *'
```

Every Monday at 9 AM UTC:

```text
0 9 * * 1
```

Cron uses:

```text
minute hour day-of-month month day-of-week
```

## Manual Trigger

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: Environment
        required: true
        default: staging
```

Use:

```yaml
${{ inputs.environment }}
```

to read the input.

## Matrix Build

Example:

```yaml
strategy:
  matrix:
    python-version: ['3.10', '3.11', '3.12']
```

Three Python versions produce three jobs.

If two operating systems are also included, the combinations become:

```text
3 Python versions × 2 operating systems = 6 jobs
```

## Exclude

Example:

```yaml
exclude:
  - os: windows-latest
    python-version: '3.10'
```

This removes one matrix combination.

## `fail-fast`

- `true` (default): a failing matrix job can cancel in-progress matrix jobs.
- `false`: other matrix jobs continue even if one fails.

