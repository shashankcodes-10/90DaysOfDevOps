# Day 23 – Git Branching & Working with GitHub

## Objective

Today I practiced Git branching and connecting my local Git repository to GitHub using SSH.

I also practiced pushing branches, pulling changes, fetching remote changes, and merging remote changes into my local branch.

---

# Task 1 – Understanding Branches

## 1. What is a branch in Git?

A branch is a separate line of development in Git.

It allows me to work on changes separately without directly changing another branch.

For example:

```text
main
 |
 └── feature-1
```

---

## 2. Why do we use branches?

Branches allow me to develop features or make changes without affecting the main code until I am ready to merge them.

This keeps the main branch more stable.

---

## 3. What is HEAD?

`HEAD` points to the branch or commit that I am currently working on.

For example:

```text
HEAD -> feature-1
```

means I am currently working on `feature-1`.

---

## 4. What happens when switching branches?

When I switch branches, Git changes the files in my working directory to match the selected branch.

Changes committed on one branch may not be visible when I switch to another branch.

---

# Task 2 – Branching Commands

## Check Existing Branches

I used:

```bash
git branch
```

### Observation

This displayed the branches available in my local repository.

---

## Switch to `feature-1`

I used:

```bash
git checkout feature-1
```

### Observation

I switched from my current branch to `feature-1`.

---

## Push `feature-1`

I pushed the branch to GitHub using:

```bash
git push origin feature-1
```

### Observation

The `feature-1` branch was pushed to the GitHub remote repository.

---

# Task 3 – Connect Local Repository to GitHub

## Check Existing Remote

```bash
git remote -v
```

This showed the remote repository configured for my local Git repository.

---

## Add GitHub Remote

I configured the GitHub repository using:

```bash
git remote add origin git@github.com:shashankcodes-10/git-push-practice-.git
```

### Remote

```text
origin
```

### GitHub Repository

```text
git@github.com:shashankcodes-10/git-push-practice-.git
```

---

## Verify Remote

```bash
git remote -v
```

### Observation

The `origin` remote was pointing to my GitHub repository.

---

# Task 4 – SSH Key Setup

I practiced creating an SSH key using:

```bash
ssh-keygen
```

### Check SSH Directory

```bash
ls -la ~/.ssh
```

This displayed the files inside my SSH directory.

---

## Check SSH Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

### Observation

This displayed my SSH public key, which can be added to GitHub to authenticate Git operations over SSH.

---

# Task 5 – Push Local Repository to GitHub

## Push `master`

I practiced:

```bash
git push origin master
```

### Observation

The local `master` branch was pushed to the `origin` remote.

---

## Push `main`

I also practiced:

```bash
git push origin main
```

### Observation

I tested pushing the `main` branch to the GitHub remote.

---

## Verify Remote

```bash
git remote -v
```

This confirmed the configured GitHub remote.

---

# Task 6 – Pull from GitHub

I switched to the `feature-1` branch:

```bash
git checkout feature-1
```

Then I practiced:

```bash
git pull origin feature-1
```

### Observation

`git pull` fetched changes from the remote `feature-1` branch and integrated them into my local branch.

---

# Task 7 – Fetch Remote Changes

I switched back to the `master` branch:

```bash
git checkout master
```

Then I used:

```bash
git fetch origin master
```

### Observation

`git fetch` downloaded the latest information from the remote `master` branch without directly merging it into my current branch.

---

# Task 8 – Merge Remote Changes

After fetching the remote branch, I used:

```bash
git merge origin/master
```

### Observation

The changes from `origin/master` were merged into my current local `master` branch.

---

# Verify Changes

I checked the files:

```bash
ls
```

I also checked the last few lines of my Git commands file:

```bash
cat git-commands.md | tail -n 5
```

After the merge, I checked it again:

```bash
cat git-commands.md | tail -n 5
```

### Observation

This allowed me to verify the contents of `git-commands.md` after the merge.

---

# GitHub Workflow I Practiced

My practice workflow was:

```text
Local Repository
      |
      ↓
Configure Remote
      |
      ↓
origin → GitHub
      |
      ↓
Push Branch
      |
      ↓
GitHub
      |
      ↓
Fetch / Pull
      |
      ↓
Local Repository
```

---

# Branch Workflow

I practiced working with `feature-1`:

```text
main/master
    |
    └── feature-1
          |
          ├── Make changes
          |
          ├── Commit
          |
          └── Push to GitHub
```

I then switched branches using:

```bash
git checkout feature-1
```

and:

```bash
git checkout master
```

---

# Origin vs Upstream

## Origin

`origin` is the name I used for my GitHub remote repository.

I configured it with:

```bash
git remote add origin git@github.com:shashankcodes-10/git-push-practice-.git
```

So in my practice:

```text
origin → my GitHub repository
```

## Upstream

I did not practice configuring an `upstream` remote during this session.

In a fork-based workflow, `upstream` is commonly used for the original repository.

---

# Git Fetch vs Git Pull

## `git fetch`

I practiced:

```bash
git fetch origin master
```

`git fetch` downloads information from the remote repository without automatically merging the changes into my current branch.

---

## `git pull`

I practiced:

```bash
git pull origin feature-1
```

`git pull` gets changes from the remote repository and integrates them into the current local branch.

---

## Difference

```text
git fetch
    ↓
Download remote changes
    ↓
No automatic merge
```

```text
git pull
    ↓
Fetch remote changes
    ↓
Integrate changes
```

---

# SSH Commands Practiced

```bash
ssh-keygen

ls -la ~/.ssh

cd ~/.ssh

ls

cat ~/.ssh/id_ed25519.pub
```

These commands helped me create and inspect my SSH keys.

---

# Git Commands Practiced

## Remote

```bash
git remote -v

git remote add origin git@github.com:shashankcodes-10/git-push-practice-.git
```

## Branches

```bash
git branch

git checkout feature-1

git checkout master
```

## Push

```bash
git push origin master

git push origin main

git push origin feature-1
```

## Pull

```bash
git pull origin feature-1
```

## Fetch

```bash
git fetch origin master
```

## Merge

```bash
git merge origin/master
```

## Verify Files

```bash
ls

cat git-commands.md | tail -n 5
```

---

# Commands Added to `git-commands.md`

The following commands should be added to my existing Git reference:

```bash
git remote -v

git remote add origin <repository-url>

git branch

git checkout feature-1

git checkout master

git push origin master

git push origin main

git push origin feature-1

git pull origin feature-1

git fetch origin master

git merge origin/master
```

---

# What I Learned

### 1. Git Branching

I practiced switching between branches using:

```bash
git checkout feature-1
```

Branches allow changes to be developed separately.

### 2. GitHub Remote and SSH

I connected my local repository to GitHub using an SSH remote:

```bash
git remote add origin git@github.com:shashankcodes-10/git-push-practice-.git
```

I also generated and viewed an SSH public key using `ssh-keygen` and `cat ~/.ssh/id_ed25519.pub`.

### 3. Fetch, Pull and Merge

I practiced the difference between fetching and pulling:

```bash
git fetch origin master
```

downloads remote information without automatically merging it.

```bash
git pull origin feature-1
```

fetches and integrates changes.

I also manually merged a remote branch using:

```bash
git merge origin/master
```

---

# Day 23 Summary

Today I practiced Git with a remote GitHub repository.

The main workflow I practiced was:

```text
Create Branch
     ↓
Checkout Branch
     ↓
Make Changes
     ↓
Commit
     ↓
Push to GitHub
     ↓
Fetch / Pull Changes
     ↓
Merge
```

I also learned how SSH keys can be used to authenticate Git operations with GitHub.
