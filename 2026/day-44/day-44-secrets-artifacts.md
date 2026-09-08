# Day 44 – Secrets, Artifacts & Real Tests in CI

## GitHub Secrets

A repository secret named `MY_SECRET_MESSAGE` can be referenced as:

```yaml
${{ secrets.MY_SECRET_MESSAGE }}
```

The actual value should never be printed to logs.

Safe verification:

```yaml
- name: Check secret
  env:
    MY_SECRET: ${{ secrets.MY_SECRET_MESSAGE }}
  run: |
    if [ -n "$MY_SECRET" ]; then
      echo "The secret is set: true"
    else
      echo "The secret is set: false"
      exit 1
    fi
```

Secrets protect credentials and sensitive configuration from being hardcoded into workflows.

## Docker Credentials

The following repository secrets are used for later Docker publishing:

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

## Artifacts

Generate a file:

```bash
mkdir -p reports
echo "CI test report" > reports/test-report.txt
```

Upload:

```yaml
- name: Upload report
  uses: actions/upload-artifact@v4
  with:
    name: test-report
    path: reports/test-report.txt
```

Download from another job:

```yaml
- name: Download report
  uses: actions/download-artifact@v4
  with:
    name: test-report
```

Artifacts are useful for test reports, logs, binaries and other outputs that need to survive after a job finishes.

## Running Tests

A CI workflow should:

1. Check out the repository.
2. Install dependencies.
3. Run tests/scripts.
4. Return a non-zero exit code when tests fail.

Example:

```yaml
- uses: actions/checkout@v4

- name: Run tests
  run: |
    chmod +x script.sh
    ./script.sh
```

A deliberate failure should make the workflow red. After fixing the script, the workflow should return to green.

## Caching

Caching can reduce repeated dependency downloads.

Example:

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache
    key: ${{ runner.os }}-dependencies-${{ hashFiles('**/requirements.txt') }}
```

The cache is managed by GitHub Actions and can be reused by later workflow runs when the cache key matches.

