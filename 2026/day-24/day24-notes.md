# Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick

## Task

Today I practiced advanced Git operations by working with branches, merging, rebasing, squashing commits, temporarily storing work with stash, and applying a specific commit with cherry-pick.

> **Note:** My repository uses `master` as the main branch name, so the commands and observations below use `master` instead of `main`.

---

# Task 1: Git Merge – Hands-On

## 1. Feature Login

I already had the following branches:

```bash
git branch
```

Relevant branches included:

```text
feature-1
feature-2
feature-hotfix
feature-login
feature-signup
master
```

I worked on `feature-login` and created three commits:

```text
5038a1b adding new commit
5285d67 adding new commit
c61691c adding 3 commit
```

The commits were created using:

```bash
git checkout feature-login

echo "hello my name is shashank" >> hello.txt
git add .
git commit -m "adding new commit"

echo "hello my age is 21" >> hello.txt
git add .
git commit -m "adding new commit"

echo "End" >> hello.txt
git add .
git commit -m "adding 3 commit"
```

I checked the history:

```bash
git log --oneline
```

Output showed:

```text
c61691c (HEAD -> feature-login) adding 3 commit
5285d67 adding new commit
5038a1b adding new commit
a668e00 (master) adding testing line
```

## 2. Fast-Forward Merge

I switched to `master`:

```bash
git checkout master
```

Then merged:

```bash
git merge feature-login
```

Git returned:

```text
Updating a668e00..c61691c
Fast-forward
 hello.txt | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 hello.txt
```

### Observation

This was a **fast-forward merge** because `master` had not moved forward after `feature-login` was created.

Git simply moved the `master` pointer to the latest commit of `feature-login`.

### What is a fast-forward merge?

A fast-forward merge happens when the target branch has no new commits of its own. Git can move its branch pointer forward without creating a separate merge commit.

---

## 3. Feature Signup and Merge Commit

I created `feature-signup`:

```bash
git checkout -b feature-signup
```

I created two commits:

```text
50841ff first commit
137ad04 adding 2 commit
```

Then I switched to `master` and created another commit:

```text
0bfea18 adding file commit
```

After that I merged:

```bash
git merge feature-signup
```

Git created:

```text
6028ccb Merge branch 'feature-signup'
```

### Observation

This time the branches had diverged because both `master` and `feature-signup` had commits that the other branch did not have.

Therefore Git created a **merge commit** instead of doing a fast-forward merge.

### When does Git create a merge commit?

A merge commit is created when the two branches have diverged and Git needs to combine their separate histories.

---

## 4. Intentional Merge Conflict

I modified `hello.txt` on both branches.

On `master` I created:

```text
f692667 adding commit for merge conflict
```

On `feature-login` I created:

```text
0c740b5 adding merge conflict 2
```

Then I tried:

```bash
git checkout master
git merge feature-login
```

Git reported:

```text
Auto-merging hello.txt
CONFLICT (content): Merge conflict in hello.txt
Automatic merge failed; fix conflicts and then commit the result.
```

The file contained conflict markers similar to:

```text
<<<<<<< HEAD
can update soon
=======
new change
>>>>>>> feature-login
```

I opened the file:

```bash
vim hello.txt
```

I resolved the conflicting content manually and then ran:

```bash
git add .
git commit -m "resolved conflict"
```

This created:

```text
b489dcd resolved conflict
```

### What is a merge conflict?

A merge conflict occurs when Git cannot automatically combine changes from two branches, commonly because both branches changed the same part of the same file.

### Conflict workflow I practiced

```bash
git merge <branch>
vim <conflicted-file>
git add .
git commit -m "resolved conflict"
```

---

# Task 2: Git Rebase – Hands-On

## 1. Create Feature Dashboard

I created the branch:

```bash
git checkout -b feature-dashboard
```

Then I created three commits.

### Commit 1

```bash
touch file.txt
git add .
git commit -m "1"
```

Commit:

```text
f9ffd23 1
```

### Commit 2

```bash
echo "hello" > file.txt
git add .
git commit -m "2"
```

Commit:

```text
f8f0f7c 2
```

### Commit 3

```bash
echo "this is the second line" >> file1.txt
git add .
git commit -m "3"
```

Commit:

```text
44a7a4c 3
```

The feature branch contained:

```text
44a7a4c 3
f8f0f7c 2
f9ffd23 1
```

---

## 2. Move Master Forward

I switched to `master`:

```bash
git checkout master
```

Then created a new commit:

```bash
touch rebase-prac.txt
git add .
git commit -m "4"
```

Commit:

```text
00b6fed 4
```

Now `master` had moved ahead while the feature branch still had its own commits.

---

## 3. Rebase

I switched to another branch and first tried:

```bash
git rebase main
```

Git returned:

```text
fatal: invalid upstream 'main'
```

### Observation

My repository uses `master`, not `main`.

So I ran:

```bash
git rebase master
```

Git returned:

```text
Successfully rebased and updated refs/heads/feature-login.
```

I then checked the history:

```bash
git log --oneline --graph --all
```

The history showed the branches and their relationships.

### What does rebase do?

Rebase takes commits from one branch and replays them on top of another base commit.

### Merge vs Rebase

**Merge:**

```text
A---B---C---M
     \     /
      D---E
```

It preserves the branch structure and may create a merge commit.

**Rebase:**

```text
A---B---C---D'---E'
```

It creates a more linear history by replaying the feature commits on top of the new base.

### Why should shared commits not normally be rebased?

Rebase rewrites commit history. If commits have already been pushed and shared with other developers, rewriting them can make the shared history difficult to reconcile.

### When would I use rebase?

I would use rebase when I want to update my feature branch with the latest base branch changes and keep the history relatively linear.

I would use merge when preserving the actual branch history is more important or when working with already-shared history.

---

# Task 3: Squash Commit vs Merge Commit

## 1. Create Feature Profile

I switched to `master`:

```bash
git checkout master
```

Then created:

```bash
git checkout -b feature-profile
```

I created three commits.

### Commit 1

```bash
touch vim.txt
git add .
git commit -m "first commit"
```

Commit:

```text
fe4e2b0 first commit
```

### Commit 2

```bash
echo "first line" > vim.txt
git add .
git commit -m "second commit"
```

Commit:

```text
ad7a324 second commit
```

### Commit 3

```bash
echo "second line" >> vim.txt
git add .
git commit -m "third commit"
```

Commit:

```text
43daf8b third commit
```

---

## 2. Squash Merge

I switched to `master`:

```bash
git checkout master
```

Then ran:

```bash
git merge feature-profile --squash
```

Git showed:

```text
Updating 00b6fed..43daf8b
Fast-forward
Squash commit -- not updating HEAD
 vim.txt | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 vim.txt
```

I checked:

```bash
git status
```

The result showed the changes staged:

```text
Changes to be committed:
    new file: vim.txt
```

I then committed the staged changes:

```bash
git commit -m "adding new file"
```

Result:

```text
d8852b5 adding new file
```

### Observation

The three commits on `feature-profile` were not added individually to `master`.

Their combined changes were staged and then committed as one new commit:

```text
d8852b5 adding new file
```

### What does squash merging do?

Squash merging combines the changes introduced by multiple commits into one set of changes. The changes then need to be committed on the target branch.

### When would I use squash merge?

I would use squash when a feature branch contains many small or intermediate commits and I want the target branch to have a cleaner history.

### Trade-off

The target branch becomes cleaner, but the individual commit history from the feature branch is not preserved as separate commits on the target branch.

---

## 3. Feature Settings

I had a `feature-settings` branch with commits:

```text
a400128 1
c55a89a 2
a705ad5 3
```

The practice history showed the branch, but I did **not** record a completed regular merge of `feature-settings` into `master` in the commands provided.

Therefore, I am not claiming a regular merge was completed for this part.

### Comparison from the practice

**Squash merge:**

```bash
git merge feature-profile --squash
git commit -m "adding new file"
```

Result: feature changes became one new commit on `master`.

**Regular merge:**

```bash
git merge feature-settings
```

This command was part of the Day 24 requirement, but its successful execution was not present in my recorded practice.

---

# Task 4: Git Stash – Hands-On

## 1. Create Uncommitted Changes

I modified:

```bash
vim vim.txt
```

I committed one change first:

```bash
git add .
git commit -m "file"
```

Commit:

```text
35fe775 file
```

Then I modified `vim.txt` again without committing.

---

## 2. Try Switching Branches

I tried:

```bash
git checkout master
```

Git stopped me:

```text
error: Your local changes to the following files would be overwritten by checkout:
    vim.txt
Please commit your changes or stash them before you switch branches.
Aborting
```

### Observation

Git prevented the branch switch because my uncommitted changes could have been overwritten.

---

## 3. Use Git Stash

I ran:

```bash
git stash
```

Git returned:

```text
Saved working directory and index state WIP on feature-profile: 35fe775 file
```

I could then switch branches:

```bash
git checkout master
```

---

## 4. Create Multiple Stashes

I modified `vim.txt` again and created another stash:

```bash
git stash
```

Then:

```bash
git stash list
```

Output:

```text
stash@{0}: WIP on master: a705ad5 3
stash@{1}: WIP on feature-profile: 35fe775 file
```

---

## 5. Mistake: `git pop`

I accidentally ran:

```bash
git pop a705ad5
```

Git returned:

```text
git: 'pop' is not a git command.
```

Correct command:

```bash
git stash pop
```

---

## 6. Mistake: Using a Commit Hash

I then tried:

```bash
git stash pop a705ad5
```

Git returned:

```text
fatal: 'a705ad5' is not a stash-like commit
```

### Lesson

A stash is referenced using:

```text
stash@{0}
stash@{1}
```

not by a normal commit hash.

---

## 7. Apply a Specific Stash

I ran:

```bash
git stash pop stash@{0}
```

The changes were restored:

```text
modified: vim.txt
```

and the successfully applied stash was dropped.

---

## 8. Apply the Remaining Stash

I checked:

```bash
git stash list
```

There was one stash remaining:

```text
stash@{0}: WIP on feature-profile: 35fe775 file
```

I ran:

```bash
git stash pop stash@{0}
```

Git reported:

```text
error: Your local changes to the following files would be overwritten by merge:
    vim.txt
```

The stash was kept:

```text
The stash entry is kept in case you need it again.
```

### What is the difference between `git stash pop` and `git stash apply`?

```bash
git stash pop
```

Applies the stash and removes it if it is successfully applied.

```bash
git stash apply
```

Applies the stash but keeps it in the stash list.

### When would I use stash?

I would use stash when I have unfinished work and need to temporarily switch branches for another task, such as an urgent production fix.

---

# Task 5: Cherry Picking

## 1. Create Feature Hotfix

I created:

```bash
git checkout -b feature-hotfix
```

I then created three commits.

### Commit 1

```bash
touch cherry.txt
git add .
git commit -m "1"
```

Commit:

```text
667da43 1
```

### Commit 2

```bash
echo "hello" > cherry.txt
git add .
git commit -m "2"
```

Commit:

```text
0158ac4 2
```

### Commit 3

```bash
echo "this is second line" >> cherry.txt
git add .
git commit -m "3"
```

Commit:

```text
ee6eabe 3
```

The branch history was:

```text
ee6eabe 3
0158ac4 2
667da43 1
```

---

## 2. Switch to Master

I ran:

```bash
git checkout master
```

Then:

```bash
git status
```

Output:

```text
On branch master
nothing to commit, working tree clean
```

---

## 3. Cherry-Pick Only the Second Commit

The second commit was:

```text
0158ac4
```

I first made a typo:

```bash
git cherr-pick 0158ac4
```

Git returned:

```text
git: 'cherr-pick' is not a git command.
```

The correct command was:

```bash
git cherry-pick 0158ac4
```

---

## 4. Cherry-Pick Conflict

The cherry-pick produced:

```text
CONFLICT (modify/delete): cherry.txt deleted in HEAD and modified in 0158ac4 (2).

Version 0158ac4 (2) of cherry.txt left in tree.

error: could not apply 0158ac4... 2
```

Git gave the following options:

```bash
git cherry-pick --continue
git cherry-pick --skip
git cherry-pick --abort
```

I resolved the file by staging it:

```bash
git add cherry.txt
```

I accidentally tried to start the cherry-pick again:

```bash
git cherry-pick 0158ac4
```

Git rejected it because the operation was already in progress.

I then correctly continued:

```bash
git cherry-pick --continue
```

Git created:

```text
[master 2968e59] 2
```

### Observation

The original commit was:

```text
0158ac4 2
```

The cherry-picked commit on `master` became:

```text
2968e59 2
```

This shows that cherry-pick creates a new commit on the target branch.

---

## What does cherry-pick do?

Cherry-pick takes the changes introduced by a specific commit and applies those changes to the current branch.

## When would I use cherry-pick?

I would use cherry-pick when I need one particular fix or change from another branch without merging the entire branch.

## What can go wrong?

Cherry-picking can result in conflicts if the selected commit changes files or lines that differ on the target branch.

In my practice, `cherry.txt` produced a conflict, which I resolved before continuing.

---

# Commands Practiced

## Merge

```bash
git merge <branch>
git merge --squash <branch>
```

## Rebase

```bash
git rebase master
```

## Stash

```bash
git stash
git stash list
git stash pop
git stash pop stash@{0}
git stash apply stash@{0}
```

## Cherry-Pick

```bash
git cherry-pick <commit>
git cherry-pick --continue
git cherry-pick --skip
git cherry-pick --abort
```

## History

```bash
git log --oneline
git log --oneline --graph --all
```

---

# Mistakes and Lessons

## Mistake 1: Running Git Outside the Repository

```bash
git branch
```

Result:

```text
fatal: not a git repository
```

I fixed it by entering the repository:

```bash
cd devops-git-practice/
```

---

## Mistake 2: `git addd`

I accidentally typed:

```bash
git addd .
```

Correct:

```bash
git add .
```

---

## Mistake 3: `git git`

I accidentally typed:

```bash
git git .
```

Correct:

```bash
git add .
```

---

## Mistake 4: `--online`

I typed:

```bash
git log --online
```

Correct:

```bash
git log --oneline
```

---

## Mistake 5: Rebasing `main`

I tried:

```bash
git rebase main
```

Result:

```text
fatal: invalid upstream 'main'
```

My repository uses:

```text
master
```

So I used:

```bash
git rebase master
```

---

## Mistake 6: `git pop`

I typed:

```bash
git pop
```

Correct:

```bash
git stash pop
```

---

## Mistake 7: Using a Commit Hash for Stash

I tried:

```bash
git stash pop a705ad5
```

Correct:

```bash
git stash pop stash@{0}
```

---

## Mistake 8: `cherr-pick`

I typed:

```bash
git cherr-pick 0158ac4
```

Correct:

```bash
git cherry-pick 0158ac4
```

---

## Mistake 9: Starting Another Cherry-Pick During a Conflict

After the cherry-pick entered a conflict state, I tried to start it again:

```bash
git cherry-pick 0158ac4
```

The correct action was:

```bash
git cherry-pick --continue
```

after resolving and staging the conflict.

---

# Merge vs Rebase vs Squash vs Stash vs Cherry-Pick

| Operation | Purpose |
|---|---|
| `git merge` | Combines two branch histories |
| `git rebase` | Replays commits onto another base |
| `git merge --squash` | Combines changes from multiple commits into one new commit |
| `git stash` | Temporarily stores uncommitted work |
| `git cherry-pick` | Applies one specific commit to the current branch |

---

# Reflection

### Fast-forward merge

A fast-forward merge moves the target branch pointer forward because there are no independent commits on the target branch.

### Merge commit

A merge commit combines two diverged histories into one.

### Rebase

Rebase replays commits on top of another base and produces a more linear history.

### Squash

Squash combines multiple commits' changes into one new commit on the target branch.

### Stash

Stash temporarily stores unfinished work so I can switch branches without committing incomplete changes.

### Cherry-pick

Cherry-pick lets me apply one particular commit without merging the entire branch.

---

# Practical Workflow I Learned

## If I need to combine a feature branch

```bash
git checkout master
git merge feature-name
```

## If I need the latest master changes on my feature branch

```bash
git checkout feature-name
git rebase master
```

## If I have unfinished work and need to switch branches

```bash
git stash
git checkout another-branch
```

Later:

```bash
git stash pop
```

## If I need only one commit from another branch

```bash
git cherry-pick <commit-hash>
```

If there is a conflict:

```bash
# resolve the file
git add <file>
git cherry-pick --continue
```

---

# Day 24 Summary

| Task | Topic | Practice Result |
|---|---|---|
| Task 1 | Merge | Fast-forward, merge commit and conflict practiced |
| Task 2 | Rebase | Rebase onto `master` practiced |
| Task 3 | Squash | Squash merge practiced |
| Task 4 | Stash | Multiple stashes and `stash pop` practiced |
| Task 5 | Cherry-pick | Second commit selected and conflict resolved |

## Key Takeaway

Today I learned that Git provides different tools for different situations:

```text
Combine branches
    ↓
  MERGE

Keep a linear history
    ↓
  REBASE

Combine many small commits
    ↓
  SQUASH

Temporarily save unfinished work
    ↓
  STASH

Take one specific commit
    ↓
CHERRY-PICK
```

The command I found especially useful for understanding the complete branch history was:

```bash
git log --oneline --graph --all
```

It makes branch divergence, merges, and commit relationships much easier to understand.
