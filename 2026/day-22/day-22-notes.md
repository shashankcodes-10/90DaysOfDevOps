# Day 22 – Introduction to Git: Your First Repository

## Objective

Today I practiced the basics of Git by creating a local repository, configuring Git, creating a Git commands reference, staging and committing changes, and viewing commit history.

---

# Task 1 – Install and Configure Git

## Check Git Version

```bash
git --version
```

This verified that Git was installed on my system.

---

## Configure Git Username

```bash
git config --global user.name "shashank"
```

This configured the username that Git associates with my commits.

---

## Configure Git Email

```bash
git config --global user.email "u10shashank@gmail.com"
```

This configured the email associated with my commits.

---

## Verify Configuration

```bash
git config --list
```

This displayed my current Git configuration.

---

# Task 2 – Create Git Project

## Create Project Directory

```bash
mkdir devops-git-practice
```

---

## Enter the Directory

```bash
cd devops-git-practice/
```

---

## Initialize Git

```bash
git init
```

This initialized the directory as a Git repository.

---

## Check Repository Status

```bash
git status
```

This showed the current state of the repository.

---

## Explore `.git`

I checked the hidden files using:

```bash
ls -a
```

Then I entered the `.git` directory:

```bash
cd .git
```

and listed its contents:

```bash
ls
```

The `.git` directory contains the internal information Git needs to manage the repository.

---

# Task 3 – Git Commands Reference

I created:

```text
git-commands.md
```

The file contains the Git commands I practiced, organized into:

* Setup & Config
* Repository Setup
* Basic Workflow
* Viewing History

---

# Task 4 – Stage and Commit

## Check Status

```bash
git status
```

---

## Stage the File

```bash
git add git-commands.md
```

---

## Commit the Changes

```bash
git commit -m "first commit"
```

This created my first commit.

---

## View Commit History

```bash
git log
```

This displayed detailed information about my commits.

---

# Task 5 – Build Commit History

After the first commit, I modified `git-commands.md` and created additional commits.

## Second Commit

```bash
git add git-commands.md
git commit -m "adding restore command"
```

---

## Third Commit

```bash
git add git-commands.md
git commit -m "adding git log command"
```

---

## Fourth Commit

```bash
git add .
git commit -m "adding git log -- online command"
```

---

## View Compact History

```bash
git log --oneline
```

This displayed the commits in a compact format.

My practice resulted in multiple commits, which helped me understand how Git keeps a history of changes.

---

# Task 6 – Understanding the Git Workflow

## 1. What is the difference between `git add` and `git commit`?

`git add` moves the changes I want to include into the staging area.

`git commit` takes the staged changes and saves them as a permanent snapshot in the Git repository.

Example:

```bash
git add git-commands.md
git commit -m "update git commands"
```

---

## 2. What does the staging area do?

The staging area allows me to choose exactly which changes should be included in the next commit.

Git does not automatically commit every change because I may have multiple changes and may want to group only specific changes into one commit.

The workflow is:

```text
Working Directory
       ↓
   git add
       ↓
Staging Area
       ↓
  git commit
       ↓
 Repository
```

---

## 3. What information does `git log` show?

`git log` shows the history of commits in the repository.

It provides information such as:

* Commit ID
* Author
* Date
* Commit message

I used:

```bash
git log
```

and:

```bash
git log --oneline
```

The second command gives a shorter view of the history.

---

## 4. What is the `.git/` folder?

The `.git/` directory is created when I run:

```bash
git init
```

It contains Git's internal repository information and metadata.

If the `.git/` directory is deleted, the directory will no longer have its local Git repository history and Git will no longer recognize it as the same initialized repository.

---

## 5. Difference Between Working Directory, Staging Area, and Repository

### Working Directory

This is where I create and modify files.

Example:

```text
git-commands.md
```

### Staging Area

This contains the changes selected using:

```bash
git add
```

These changes are prepared for the next commit.

### Repository

The repository contains the committed history.

Changes move through the workflow:

```text
Working Directory
       ↓
   git add
       ↓
Staging Area
       ↓
  git commit
       ↓
Repository
```

---

# Commands I Practiced

```bash
git --version

git config --global user.name "shashank"

git config --global user.email "u10shashank@gmail.com"

git config --list

mkdir devops-git-practice

cd devops-git-practice/

git init

git status

ls -a

cd .git

ls

cd ..

git add git-commands.md

git add .

git commit -m "first commit"

git log

git log --oneline
```

---

# What I Learned

1. **Git tracks changes over time** by storing commits in a repository.

2. **The staging area** gives me control over which changes I want to include in the next commit.

3. **Commit history** allows me to see how a project has changed and use commands such as `git log` and `git log --oneline` to review that history.

---

# Day 22 Summary

Today I created my first Git repository and practiced the basic Git workflow:

```text
Initialize
    ↓
Modify
    ↓
git status
    ↓
git add
    ↓
git commit
    ↓
git log
```

I also created a `git-commands.md` reference that I can continue updating during the upcoming Git practice days.
