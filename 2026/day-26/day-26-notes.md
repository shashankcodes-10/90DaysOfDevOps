# Day 26 – GitHub CLI: Manage GitHub from Your Terminal

## Task

Today I practiced using the GitHub CLI (`gh`) to manage GitHub directly from the terminal.

---

## Task 1 – Install and Authenticate

### Check GitHub CLI Version

```bash
gh --version
```

**Purpose:** Checks whether GitHub CLI is installed and displays its version.

### Authenticate with GitHub

```bash
gh auth login
```

**Purpose:** Starts the GitHub authentication process.

### Check Authentication Status

```bash
gh auth status
```

**Purpose:** Shows whether I am authenticated and which GitHub account is active.

### Authentication Methods

GitHub CLI supports authentication through:

- Browser-based authentication
- Personal Access Token

---

# Task 2 – Working with Repositories

### Create a Repository

```bash
gh repo create
```

**Purpose:** Creates a new GitHub repository directly from the terminal.

Example:

```bash
gh repo create my-test-repo --public --add-readme
```

### Clone a Repository

```bash
gh repo clone <owner>/<repo>
```

**Purpose:** Clones a GitHub repository using GitHub CLI.

### View Repository Details

```bash
gh repo view
```

**Purpose:** Displays information about the current repository.

For a specific repository:

```bash
gh repo view <owner>/<repo>
```

### List Repositories

```bash
gh repo list
```

**Purpose:** Lists repositories associated with my GitHub account.

### Open Repository in Browser

```bash
gh repo view --web
```

**Purpose:** Opens the repository directly in the browser.

### Delete a Repository

```bash
gh repo delete <owner>/<repo>
```

**Purpose:** Deletes a GitHub repository.

> This command is destructive, so it should be used carefully.

---

# Task 3 – GitHub Issues

### Create an Issue

```bash
gh issue create
```

Example:

```bash
gh issue create --title "Application Bug" --body "Application is not starting"
```

With a label:

```bash
gh issue create \
  --title "Application Bug" \
  --body "Application is not starting" \
  --label bug
```

**Purpose:** Creates a GitHub issue directly from the terminal.

### List Open Issues

```bash
gh issue list
```

**Purpose:** Lists open issues in the repository.

### View an Issue

```bash
gh issue view <issue-number>
```

**Purpose:** Displays details of a specific issue.

### Close an Issue

```bash
gh issue close <issue-number>
```

**Purpose:** Closes an issue from the terminal.

### Automation Use

`gh issue` can be useful in automation. For example, a monitoring script could automatically create a GitHub issue when a production problem is detected.

---

# Task 4 – Pull Requests

### Create a Feature Branch

```bash
git checkout -b feature-test
```

**Purpose:** Creates and switches to a new feature branch.

### Make a Change

```bash
echo "GitHub CLI practice" >> test.txt
```

### Stage and Commit

```bash
git add .
git commit -m "adding GitHub CLI practice"
```

### Push the Branch

```bash
git push -u origin feature-test
```

**Purpose:** Pushes the feature branch to GitHub.

### Create a Pull Request

```bash
gh pr create
```

Or:

```bash
gh pr create --fill
```

**Purpose:** Creates a pull request from the terminal.

`--fill` can use commit information to populate the PR title and description.

### List Pull Requests

```bash
gh pr list
```

**Purpose:** Lists pull requests for the repository.

### View a Pull Request

```bash
gh pr view <pr-number>
```

**Purpose:** Displays information about a pull request.

### Check Pull Request Status

```bash
gh pr checks <pr-number>
```

**Purpose:** Checks the CI status of a pull request.

### Merge a Pull Request

```bash
gh pr merge <pr-number>
```

Supported merge methods include:

```bash
gh pr merge <pr-number> --merge
gh pr merge <pr-number> --squash
gh pr merge <pr-number> --rebase
```

### Reviewing Someone Else's PR

I can inspect a pull request using:

```bash
gh pr view <pr-number>
```

and check its CI status using:

```bash
gh pr checks <pr-number>
```

---

# Task 5 – GitHub Actions & Workflows

### List Workflow Runs

```bash
gh run list
```

**Purpose:** Lists recent GitHub Actions workflow runs.

### View a Workflow Run

```bash
gh run view <run-id>
```

**Purpose:** Displays information about a specific workflow run.

### List Workflows

```bash
gh workflow list
```

**Purpose:** Lists GitHub Actions workflows available in the repository.

### CI/CD Use

`gh run` and `gh workflow` can be useful for:

- Checking deployment status
- Investigating failed CI/CD pipelines
- Monitoring workflow runs
- Triggering workflows
- Automating GitHub Actions operations

---

# Task 6 – Useful `gh` Tricks

## GitHub API

```bash
gh api <endpoint>
```

**Purpose:** Makes GitHub API requests directly from the terminal.

Example:

```bash
gh api repos/<owner>/<repo>
```

---

## GitHub Gist

```bash
gh gist create <file>
```

**Purpose:** Creates a GitHub Gist from a local file.

---

## GitHub Release

```bash
gh release list
```

**Purpose:** Lists releases for a repository.

Create a release:

```bash
gh release create <tag>
```

**Purpose:** Creates a new GitHub release.

---

## GitHub Alias

```bash
gh alias list
```

**Purpose:** Lists configured GitHub CLI aliases.

Create an alias:

```bash
gh alias set <alias> '<command>'
```

**Purpose:** Creates a shortcut for a frequently used command.

---

## Search GitHub Repositories

```bash
gh search repos <search-term>
```

**Purpose:** Searches GitHub repositories directly from the terminal.

---

# Useful GitHub CLI Commands

| Command | Purpose |
|---|---|
| `gh --version` | Check GitHub CLI version |
| `gh auth login` | Authenticate with GitHub |
| `gh auth status` | Check authentication status |
| `gh repo create` | Create a repository |
| `gh repo clone` | Clone a repository |
| `gh repo view` | View repository information |
| `gh repo list` | List repositories |
| `gh repo view --web` | Open repository in browser |
| `gh repo delete` | Delete a repository |
| `gh issue create` | Create an issue |
| `gh issue list` | List issues |
| `gh issue view` | View an issue |
| `gh issue close` | Close an issue |
| `gh pr create` | Create a pull request |
| `gh pr list` | List pull requests |
| `gh pr view` | View a pull request |
| `gh pr checks` | Check PR status |
| `gh pr merge` | Merge a pull request |
| `gh run list` | List workflow runs |
| `gh run view` | View workflow run |
| `gh workflow list` | List workflows |
| `gh api` | Use GitHub API |
| `gh gist create` | Create a Gist |
| `gh release list` | List releases |
| `gh release create` | Create a release |
| `gh alias list` | List aliases |
| `gh alias set` | Create an alias |
| `gh search repos` | Search repositories |

---

# Git vs GitHub CLI

| Git | GitHub CLI |
|---|---|
| Version control | GitHub platform operations |
| `git add` | `gh issue create` |
| `git commit` | `gh pr create` |
| `git push` | `gh pr merge` |
| `git pull` | `gh run list` |
| Works with Git repositories | Works with GitHub features |

**Git manages version control, while `gh` provides terminal access to GitHub-specific features.**

---

# What I Learned

1. GitHub CLI allows me to perform many GitHub operations directly from the terminal.
2. `gh issue`, `gh pr`, and `gh run` can be useful for DevOps automation and CI/CD workflows.
3. `gh api` allows GitHub's API to be accessed directly from the terminal.
4. GitHub CLI can reduce the need to switch between the terminal and browser.
5. `gh` commands can be useful when automating GitHub operations with shell scripts.

---

# Day 26 Summary

- [x] GitHub CLI installation and authentication
- [x] Repository management
- [x] GitHub Issues
- [x] Pull Requests
- [x] GitHub Actions and workflows
- [x] GitHub API
- [x] GitHub Gists
- [x] GitHub Releases
- [x] GitHub aliases
- [x] Repository search

---

# Git Commands Reference Update

I will add the following GitHub CLI commands to my existing `git-commands.md`:

```bash
gh --version
gh auth login
gh auth status

gh repo create
gh repo clone
gh repo view
gh repo list
gh repo view --web
gh repo delete

gh issue create
gh issue list
gh issue view
gh issue close

gh pr create
gh pr list
gh pr view
gh pr checks
gh pr merge

gh run list
gh run view
gh workflow list

gh api
gh gist create

gh release list
gh release create

gh alias list
gh alias set

gh search repos
```

---

# Final Reflection

GitHub CLI brings GitHub operations directly into the terminal.

Instead of switching between the terminal and browser for every operation, I can use commands such as:

```bash
gh issue create
gh pr create
gh pr checks
gh pr merge
gh run list
gh workflow list
```

This is especially useful for DevOps because these commands can be integrated into scripts, automation, and CI/CD workflows.

**Day 26 completed.**

`#90DaysOfDevOps`  
`#DevOpsKaJosh`  
`#TrainWithShubham`
