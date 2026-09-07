# Day 38 – YAML Basics

## Objective

Learn YAML syntax before using YAML extensively for CI/CD workflows.

## `person.yaml`

Example structure:

```yaml
name: Shashank
role: DevOps Learner
experience_years: 0
learning: true

tools:
  - Docker
  - Git
  - GitHub Actions
  - Jenkins
  - AWS

hobbies: [Learning DevOps, Building Projects, Coding]
```

## YAML Lists

Two common list formats are:

### Block style

```yaml
tools:
  - Docker
  - Kubernetes
  - Terraform
```

### Flow/inline style

```yaml
tools: [Docker, Kubernetes, Terraform]
```

## `server.yaml`

```yaml
server:
  name: dev-server
  ip: 192.168.1.10
  port: 8080

database:
  host: db
  name: application
  credentials:
    user: appuser
    password: change-me

startup_script_literal: |
  echo "Starting application"
  echo "Checking dependencies"

startup_script_folded: >
  echo "Starting application"
  echo "Checking dependencies"
```

## `|` vs `>`

- `|` preserves line breaks.
- `>` folds normal line breaks into spaces.

Use `|` for scripts or text where newlines matter. Use `>` for longer prose where line wrapping should not create separate lines.

## YAML Rules

- Use spaces, not tabs.
- Indentation defines structure.
- Two spaces per indentation level is a common convention.
- Boolean values can be `true` or `false`.
- Quoting can be necessary when a value contains YAML-special characters.

## Validation

Using `yamllint`:

```bash
yamllint person.yaml
yamllint server.yaml
```

Intentionally breaking indentation should produce a YAML parsing/linting error. After correcting the indentation, validation should pass.

## Spot the Difference

Correct:

```yaml
name: devops
tools:
  - docker
  - kubernetes
```

Broken:

```yaml
name: devops
tools:
- docker
  - kubernetes
```

The second list item has inconsistent indentation. YAML structure depends on indentation.

## Key Learnings

1. YAML is whitespace-sensitive.
2. Lists can use block or inline notation.
3. Literal and folded block styles behave differently.
