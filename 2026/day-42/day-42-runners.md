# Day 42 – GitHub-Hosted & Self-Hosted Runners

## GitHub-Hosted Runner

A GitHub-hosted runner is a temporary virtual machine managed by GitHub for executing Actions jobs.

Example labels:

```yaml
runs-on: ubuntu-latest
runs-on: windows-latest
runs-on: macos-latest
```

## Runner Information

A workflow can inspect the runner with:

```bash
echo "$RUNNER_OS"
hostname
whoami
```

## Pre-Installed Software

Ubuntu runners include many commonly used developer and DevOps tools.

Example checks:

```bash
docker --version
python3 --version
node --version
git --version
```

Pre-installed tools reduce setup time and make common CI jobs faster.

## Self-Hosted Runner

A self-hosted runner is a machine managed by the user or organization.

Typical setup flow:

1. GitHub repository → Settings.
2. Actions → Runners.
3. New self-hosted runner.
4. Select Linux.
5. Download and configure the runner.
6. Start the runner.
7. Verify that GitHub shows it as idle/online.

## Self-Hosted Workflow

```yaml
name: Self Hosted Runner

on:
  workflow_dispatch:

jobs:
  runner-test:
    runs-on: self-hosted

    steps:
      - name: Hostname
        run: hostname

      - name: Working directory
        run: pwd

      - name: Create file
        run: |
          echo "Created by GitHub Actions" > runner-test.txt
          cat runner-test.txt
```

## Labels

A specific runner can be targeted with labels:

```yaml
runs-on: [self-hosted, my-linux-runner]
```

Labels are useful when multiple self-hosted runners have different operating systems, hardware, tools or environments.

## GitHub-Hosted vs Self-Hosted

| | GitHub-Hosted | Self-Hosted |
|---|---|---|
| Who manages it? | GitHub | User/organization |
| Cost | Uses GitHub Actions minutes/plan | Infrastructure cost |
| Pre-installed tools | Many common tools | User controls software |
| Good for | General CI/CD | Custom infrastructure |
| Security concern | Shared service model | User responsible for host security |

