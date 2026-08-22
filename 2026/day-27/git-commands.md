# Git Commands Revision – Days 22–26

> ## Day 27 – GitHub Profile & Git Revision
>
> My GitHub profile is already improved, so instead of making unnecessary changes, I am using Day 27 to consolidate and revise the Git commands I practiced during Days 22–26.
>
> This is my personal Git reference containing the commands I actually practiced while learning repositories, commits, branching, GitHub, merging, rebasing, stash, cherry-pick, reset, revert, and GitHub CLI.

---

## 1. Git Setup & Configuration

### Check Git version
```bash
git --version
```

### Configure username
```bash
git config --global user.name "shashank"
```

### Configure email
```bash
git config --global user.email "u10shashank@gmail.com"
```

### View configuration
```bash
git config --list
```

---

## 2. Repository Setup

```bash
mkdir devops-git-practice
cd devops-git-practice
git init
git status
ls -a
ls .git
```

- `mkdir` creates the project directory.
- `cd` enters the directory.
- `git init` initializes a repository.
- `git status` shows repository state.
- `ls -a` shows hidden files.
- `ls .git` shows Git's internal repository data.

---

## 3. Basic Git Workflow

### Create, edit and read files

```bash
touch file.txt
echo "hello" > file.txt
echo "hello" >> file.txt
cat file.txt
vim file.txt
```

### Stage and commit

```bash
git add file.txt
git add .
git commit -m "first commit"
```

### Basic workflow

```text
Working Directory
       |
       | git add
       v
Staging Area
       |
       | git commit
       v
Local Repository
       |
       | git push
       v
GitHub
```

---

## 4. Viewing Changes & History

```bash
git status
git diff
git log
git log --oneline
git log --oneline --graph --all
```

- `git status` shows modified, staged and untracked files.
- `git diff` shows unstaged changes.
- `git log` shows commit history.
- `git log --oneline` shows compact history.
- `git log --oneline --graph --all` visualizes branches and commits.

---

## 5. Branching

```bash
git branch
git branch feature-1
git checkout -b feature-login
git checkout feature-login
git switch feature-login
git branch -d feature-name
```

Branches I practiced included:

```text
feature-1
feature-2
feature-login
feature-signup
feature-dashboard
feature-profile
feature-settings
feature-hotfix
```

A branch allows work to happen separately from the main branch.

---

## 6. Remote Repositories

```bash
git remote -v
git remote add origin git@github.com:shashankcodes-10/git-push-practice-.git
```

`origin` is normally the name of the main remote repository.

`upstream` is commonly used for the original repository when working with a fork.

---

## 7. Push, Pull & Fetch

```bash
git push origin master
git push origin main
git push origin feature-1
git push -u origin feature-1
git pull origin feature-1
git fetch origin master
git merge origin/master
```

### Fetch vs Pull

`git fetch` downloads remote changes without merging them.

`git pull` downloads remote changes and integrates them into the current branch.

---

## 8. Git Merge

```bash
git merge feature-login
```

### Fast-forward merge

A fast-forward merge happens when the target branch has not moved forward since the feature branch was created.

```text
A---B---C
        ^
     master
     feature
```

Git can simply move the branch pointer forward.

### Merge commit

When both branches contain separate commits, Git can create a merge commit.

```text
      C---D
     /     A---B       M
     \     /
      E---
```

---

## 9. Merge Conflicts

During practice I intentionally created a conflict by changing the same file on different branches.

```text
CONFLICT (content): Merge conflict in hello.txt
Automatic merge failed; fix conflicts and then commit the result.
```

### Resolve conflict

```bash
git status
vim hello.txt
git add .
git commit -m "resolved conflict"
```

Conflict markers:

```text
<<<<<<< HEAD
current branch
=======
other branch
>>>>>>> feature-login
```

A merge conflict occurs when Git cannot automatically determine which changes should be kept.

---

## 10. Git Rebase

I practiced:

```bash
git rebase main
```

which failed because my repository uses `master`:

```text
fatal: invalid upstream 'main'
```

The correct command was:

```bash
git rebase master
```

Then I checked:

```bash
git log --oneline --graph --all
```

### What rebase does

Before:

```text
A---B---C       master
     \
      D---E     feature
```

After:

```text
A---B---C---D'---E'
```

Rebase reapplies feature commits on top of the latest master and gives the rebased commits new IDs.

### Important

Avoid rebasing commits that have already been pushed and shared because rebase rewrites history.

---

## 11. Squash Merge

```bash
git merge feature-profile --squash
git commit -m "adding new file"
```

I created multiple commits on `feature-profile`:

```text
fe4e2b0 first commit
ad7a324 second commit
43daf8b third commit
```

After:

```bash
git merge feature-profile --squash
```

the changes were staged, and I created one commit on `master`.

Squash merge is useful when a feature branch contains many small commits and I want a cleaner main branch history.

---

## 12. Git Stash

```bash
git stash
git stash list
git stash pop stash@{0}
git stash apply stash@{0}
git stash push -m "description"
```

I tried switching branches with uncommitted changes and Git stopped me:

```text
error: Your local changes to the following files would be overwritten by checkout
```

I then used `git stash` to save the work temporarily.

### Pop vs Apply

- `git stash pop` applies the stash and removes it if successful.
- `git stash apply` applies the stash but keeps it in the stash list.

### Practice mistake

I tried:

```bash
git pop a705ad5
```

Correct:

```bash
git stash pop stash@{0}
```

A commit hash is not the same as a stash reference.

---

## 13. Cherry-Pick

I created `feature-hotfix` with:

```text
667da43  1
0158ac4  2
ee6eabe  3
```

Then I switched to `master` and attempted:

```bash
git cherry-pick 0158ac4
```

A conflict occurred:

```text
CONFLICT (modify/delete): cherry.txt deleted in HEAD and modified in 0158ac4
```

I resolved it with:

```bash
git add cherry.txt
git cherry-pick --continue
```

Useful commands:

```bash
git cherry-pick <commit>
git cherry-pick --continue
git cherry-pick --skip
git cherry-pick --abort
```

Cherry-pick is useful when I need one specific commit from another branch without merging the entire branch.

---

## 14. Git Reset

I practiced all three reset modes.

### Soft

```bash
git reset --soft d26c685
```

- Commit history moves back.
- Staged changes remain.
- Working files remain.

Then:

```bash
git commit -m "after soft commit"
```

### Mixed

```bash
git reset --mixed d26c685
```

- Commit history moves back.
- Changes become unstaged.
- Working files remain.

Then:

```bash
git add .
git commit -m "after mixed commit"
```

### Hard

```bash
git reset --hard d26c685
```

- Commit history moves back.
- Staging area resets.
- Working files reset.

### Comparison

| Command | Commit | Staging | Working Directory |
|---|---|---|---|
| `--soft` | Reset | Preserved | Preserved |
| `--mixed` | Reset | Reset | Preserved |
| `--hard` | Reset | Reset | Reset |

`git reset --hard` is destructive because uncommitted changes can be lost.

For shared/pushed commits, `git revert` is generally safer.

---

## 15. Git Revert

```bash
git revert 6eac539
git log --oneline
```

`git revert` creates a new commit that reverses the changes introduced by another commit.

### Reset vs Revert

| | `git reset` | `git revert` |
|---|---|---|
| Purpose | Move branch pointer | Reverse changes |
| Creates new commit | No | Yes |
| Original commit | Can disappear from branch history | Remains |
| Safe for shared branch | Usually no | Yes |
| Common use | Local/private history | Shared/pushed history |

---

## 16. Git Reflog

```bash
git reflog
```

Shows movements of `HEAD` and branch references.

It is useful for recovering commits after operations such as:

```bash
git reset --hard
```

Reflog is an important Git safety net.

---

# 17. Git Clone

```bash
git clone <repository-url>
```

Creates a local copy of a remote repository.

With GitHub CLI:

```bash
gh repo clone <owner>/<repo>
```

---

# 18. GitHub CLI

### Authentication

```bash
gh --version
gh auth login
gh auth status
```

### Repository commands

```bash
gh repo create
gh repo clone <owner>/<repo>
gh repo view
gh repo list
gh repo view --web
gh repo delete <owner>/<repo>
```

### Issues

```bash
gh issue create
gh issue list
gh issue view <issue-number>
gh issue close <issue-number>
```

### Pull Requests

```bash
gh pr create
gh pr create --fill
gh pr list
gh pr view <pr-number>
gh pr checks <pr-number>
gh pr merge <pr-number>
gh pr merge <pr-number> --merge
gh pr merge <pr-number> --squash
gh pr merge <pr-number> --rebase
```

### GitHub Actions

```bash
gh run list
gh run view <run-id>
gh workflow list
```

### Other useful GitHub CLI commands

```bash
gh api <endpoint>
gh gist create <file>
gh release list
gh release create <tag>
gh alias list
gh alias set <alias> '<command>'
gh search repos <search-term>
```

---

# 19. Common Mistakes I Made

### Wrong log command

```bash
git logs
```

Correct:

```bash
git log
```

### Wrong option

```bash
git log --online
```

Correct:

```bash
git log --oneline
```

### Typo

```bash
git addd .
```

Correct:

```bash
git add .
```

### Typo

```bash
git cherr-pick 0158ac4
```

Correct:

```bash
git cherry-pick 0158ac4
```

### Wrong stash command

```bash
git pop a705ad5
```

Correct:

```bash
git stash pop stash@{0}
```

### Wrong rebase target

```bash
git rebase main
```

Correct for my repository:

```bash
git rebase master
```

These mistakes helped me understand Git syntax instead of simply memorizing commands.

---

# 20. Most Important Commands for Daily Practice

## Daily workflow

```bash
git status
git add .
git commit -m "message"
git log --oneline
git diff
```

## Branching

```bash
git branch
git checkout -b feature-name
git checkout feature-name
git switch feature-name
```

## Remote

```bash
git remote -v
git push
git pull
git fetch
```

## Merge and rebase

```bash
git merge feature-name
git merge feature-name --squash
git rebase master
```

## Stash

```bash
git stash
git stash list
git stash pop
git stash apply
```

## Cherry-pick

```bash
git cherry-pick <commit>
git cherry-pick --continue
git cherry-pick --abort
```

## Undo

```bash
git reset --soft <commit>
git reset --mixed <commit>
git reset --hard <commit>
git revert <commit>
git reflog
```

## GitHub CLI

```bash
gh auth status
gh repo view
gh repo list
gh issue create
gh issue list
gh pr create
gh pr list
gh pr checks
gh pr merge
gh run list
gh workflow list
```

---

# 21. Git Workflow I Want to Remember

## Normal development

```text
Create/Edit
    ↓
git status
    ↓
git diff
    ↓
git add .
    ↓
git commit
    ↓
git log --oneline
    ↓
git push
```

## Feature development

```text
master
  |
  └── feature branch
          |
          ├── commit
          ├── commit
          └── commit
                |
                ↓
              push
                |
                ↓
          Pull Request
                |
                ↓
              Review
                |
                ↓
              Merge
```

## When something goes wrong

```text
Uncommitted work
      ↓
git stash

Local commit mistake
      ↓
git reset

Shared commit mistake
      ↓
git revert

Need one commit
      ↓
git cherry-pick

Lost commit
      ↓
git reflog

Merge conflict
      ↓
git status
      ↓
resolve file
      ↓
git add .
      ↓
git commit
```

---

# 22. Final Revision

I do not need to memorize every Git command.

The important thing is to understand the repository state and know what action is required.

The commands I should be most comfortable with are:

```bash
git status
git add .
git commit -m "message"
git log --oneline
git diff

git branch
git checkout -b feature-name
git checkout branch-name

git remote -v
git push
git pull
git fetch

git merge
git rebase

git stash
git stash list
git stash pop

git cherry-pick <commit>

git reset --soft <commit>
git reset --mixed <commit>
git reset --hard <commit>

git revert <commit>
git reflog
```

For GitHub CLI:

```bash
gh auth status
gh repo view
gh repo list
gh issue create
gh issue list
gh pr create
gh pr list
gh pr checks
gh pr merge
gh run list
gh workflow list
```

---

# 23. Day 27 Reflection

My GitHub profile is already improved, so I used Day 27 for Git and GitHub command revision instead of making unnecessary profile changes.

During Days 22–26 I practiced:

- Git repository creation
- Git configuration
- Staging and commits
- Commit history
- Branching
- Remote repositories
- Push, pull and fetch
- Merge
- Merge conflicts
- Rebase
- Squash merge
- Stash
- Cherry-pick
- Reset
- Revert
- Reflog
- GitHub CLI
- GitHub repositories
- Issues
- Pull requests
- GitHub Actions

## Main takeaway

Git is not about memorizing hundreds of commands.

It is about understanding the current state of the repository and choosing the correct operation.

> **Understand the workflow first. Commands become easier through practice.**

---

# 90 Days of DevOps

**Day 27 – Git & GitHub Revision**

`#90DaysOfDevOps`

`#DevOpsKaJosh`

`#TrainWithShubham`
