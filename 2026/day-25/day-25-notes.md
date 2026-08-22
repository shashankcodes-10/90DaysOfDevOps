# Day 25 – Git Reset vs Revert & Branching Strategies

## Task

Today I practiced **Git Reset**, **Git Revert**, and reviewed common **branching strategies**. I used my `devops-git-practice` repository and documented what I actually observed.

> **Repository note:** My default branch is `master`.

---

# Task 1 – Git Reset

## Create three commits

```bash
touch file-prac.txt
git add .
git commit -m "first commit"

echo "first line" >> file-prac.txt
git add .
git commit -m "second commit"

echo "second line" >> file-prac.txt
git add .
git commit -m "third commit"
```

Check the history:

```bash
git log --oneline
```

---

## `git reset --soft`

```bash
git reset --soft d26c685
git status
```

**Observation**

- `HEAD` moved back.
- Changes from the removed commit stayed **staged**.

I recommitted them:

```bash
git commit -m "after soft commit"
```

---

## `git reset --mixed`

```bash
git reset --mixed d26c685
git status
```

**Observation**

- `HEAD` moved back.
- Changes became **unstaged**.
- Files were still modified.

I staged and committed again:

```bash
git add .
git commit -m "after mixed commmit"
```

---

## `git reset --hard`

```bash
git reset --hard d26c685
git status
git log --oneline
```

**Observation**

- `HEAD` moved back.
- Staged and working-tree changes were discarded.

---

## Reset comparison

| Mode | HEAD | Staging | Working tree |
|---|---|---|---|
| `--soft` | Moves | Keeps staged | Keeps changes |
| `--mixed` | Moves | Unstages | Keeps changes |
| `--hard` | Moves | Clears | Discards changes |

**Most destructive:** `git reset --hard`

**Should I reset pushed commits?** No. Prefer `git revert` for shared history.

---

# Task 2 – Git Revert

## Create three commits

```bash
touch revert.txt
git add .
git commit -m "x"

touch revert1.txt
git add .
git commit -m "y"

touch revert2.txt
git add .
git commit -m "z"
```

History:

```bash
git log --oneline
```

---

## Revert the middle commit

```bash
git revert 6eac539
git log --oneline
```

**Observation**

- Commit **Y** stayed in history.
- Git created a **new revert commit** that undid Y.

### Reset vs Revert

| | `git reset` | `git revert` |
|---|---|---|
| History rewritten | Yes (local) | No |
| Safe for shared branches | No | Yes |
| Best for | Local cleanup | Undoing pushed commits |

---

# Task 3 – Branching Strategies

## GitFlow

```text
master
  │
develop
  ├── feature/*
  ├── release/*
  └── hotfix/*
```

**Use:** Scheduled releases

---

## GitHub Flow

```text
main
 └── feature → Pull Request → main
```

**Use:** Continuous delivery

---

## Trunk-Based Development

```text
Developer A ─┐
Developer B ─┼──► main
Developer C ─┘
```

**Use:** CI/CD with frequent integration

### My choices

- **Startup shipping fast:** GitHub Flow
- **Large team with scheduled releases:** GitFlow

---

# Task 4 – Commands I Practiced

## Reset

```bash
git reset --soft <commit>
git reset --mixed <commit>
git reset --hard <commit>
```

## Revert

```bash
git revert <commit>
```

## History

```bash
git log --oneline
git status
```

---

# Mistakes I Made

| Mistake | Fix |
|---|---|
| `git commmit` | `git commit` |
| `git log --online` | `git log --oneline` |
| `git staus` | `git status` |

These errors helped me remember the correct command names.

---

# Key Takeaways

1. **Reset** rewrites local history; **Revert** preserves history by creating a new commit.
2. `--soft`, `--mixed`, and `--hard` differ in how they treat the staging area and working tree.
3. Never rewrite shared history with `git reset`; use `git revert` instead.

---

# Practice Summary

| Task | Status |
|---|---|
| Reset (`--soft`, `--mixed`, `--hard`) | Completed |
| Revert | Completed |
| Reset vs Revert comparison | Completed |
| Branching strategies review | Completed |
| Git command reference update | Completed |

**Day 25 completed.**

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
