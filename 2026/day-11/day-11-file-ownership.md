# Day 11 – File Ownership Challenge (chown & chgrp)

## Objective

Learn how Linux file ownership works and practice changing file owners and groups using `chown` and `chgrp`.

---

# Task 1 – Understanding Ownership

## List Files

```bash
ls -l
```

### Example Output

```text
total 12
-r--r--r-- 1 ubuntu ubuntu    0 Aug  6 09:56 devops.txt
-rw-r----- 1 ubuntu ubuntu  121 Aug  6 10:03 notes.txt
drwxr-xr-x 2 ubuntu ubuntu 4096 Aug  6 10:15 project
-rw-rw-r-- 1 ubuntu ubuntu   32 Aug  6 10:12 script.sh
```

### Understanding Ownership

```
-rw-r--r--

Owner      Group
ubuntu     ubuntu
```

### Observation

- The **owner** is the user who owns the file.
- The **group** determines which group members can access the file.

---

# Task 2 – Basic chown Operations

## Create a File

```bash
touch devops-file.txt
```

## Check Current Owner

```bash
ls -l devops-file.txt
```

### Change Owner to tokyo

```bash
sudo chown tokyo devops-file.txt
```

### Verify

```bash
ls -l devops-file.txt
```

### Change Owner to berlin

```bash
sudo chown berlin devops-file.txt
```

### Verify

```bash
ls -l devops-file.txt
```

### Observation

Ownership changed successfully from the current user to **tokyo**, then to **berlin**.

---

# Task 3 – Basic chgrp Operations

## Create File

```bash
touch team-notes.txt
```

## Check Current Group

```bash
ls -l team-notes.txt
```

## Create Group

```bash
sudo groupadd money-heist
```

## Change Group

```bash
sudo chgrp money-heist team-notes.txt
```

## Verify

```bash
ls -l team-notes.txt
```

### Observation

Successfully changed the group ownership to **heist-team**.

---

# Task 4 – Change Owner and Group Together

## Create File

```bash
touch project-config.yaml
```

## Change Owner and Group

```bash
sudo chown professor:money-heist project-config.yaml
```

## Verify

```bash
ls -l project-config.yaml
```

---

## Create Directory

```bash
mkdir app-logs
```

## Change Owner and Group

```bash
sudo chown berlin:money-heist app-logs
```

## Verify

```bash
ls -ld app-logs
```

### Observation

Owner and group were successfully updated using a single command.

---

# Task 5 – Recursive Ownership

## Create Directory Structure

```bash
mkdir -p heist-project/vault
mkdir -p heist-project/plans

touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf
```

## Create Group

```bash
sudo groupadd planners
```

## Change Ownership Recursively

```bash
sudo chown -R professor:planners heist-project
```

## Verify

```bash
ls -lR heist-project
```

### Observation

All directories and files inside **heist-project** now belong to **professor** and the **planners** group.

---

# Task 6 – Practice Challenge

## Create Groups

```bash
sudo groupadd vault-team

sudo groupadd tech-team
```

---

## Create Directory

```bash
mkdir bank-heist
```

---

## Create Files

```bash
touch bank-heist/access-codes.txt

touch bank-heist/blueprints.pdf

touch bank-heist/escape-plan.txt
```

---

## Set Ownership

### Access Codes

```bash
sudo chown tokyo:vault-team bank-heist/access-codes.txt
```

### Blueprints

```bash
sudo chown berlin:tech-team bank-heist/blueprints.pdf
```

### Escape Plan

```bash
sudo chown nairobi:vault-team bank-heist/escape-plan.txt
```

---

## Verify

```bash
ls -l bank-heist
```

### Example Output

```text
-rw-rw-r-- 1 tokyo   vault-team 0 Aug  6 10:50 access-codes.txt
-rw-rw-r-- 1 berlin  tech-team  0 Aug  6 10:50 blueprints.pdf
-rw-rw-r-- 1 nairobi vault-team 0 Aug  6 10:50 escape-plan.txt
```

### Observation

Each file has the correct owner and group.

---

# Commands Used

```bash
ls -l

touch devops-file.txt

sudo chown tokyo devops-file.txt

sudo chown berlin devops-file.txt

touch team-notes.txt

sudo groupadd heist-team

sudo chgrp heist-team team-notes.txt

touch project-config.yaml

sudo chown professor:heist-team project-config.yaml

mkdir app-logs

sudo chown berlin:heist-team app-logs

mkdir -p heist-project/vault

mkdir -p heist-project/plans

touch heist-project/vault/gold.txt

touch heist-project/plans/strategy.conf

sudo groupadd planners

sudo chown -R professor:planners heist-project

mkdir bank-heist

touch bank-heist/access-codes.txt

touch bank-heist/blueprints.pdf

touch bank-heist/escape-plan.txt

sudo groupadd vault-team

sudo groupadd tech-team

sudo chown tokyo:vault-team bank-heist/access-codes.txt

sudo chown berlin:tech-team bank-heist/blueprints.pdf

sudo chown nairobi:vault-team bank-heist/escape-plan.txt

ls -l

ls -lR heist-project

ls -l bank-heist
```

---

# Verification Checklist

- ✅ Understood Linux file ownership
- ✅ Changed file owner using `chown`
- ✅ Changed group using `chgrp`
- ✅ Changed owner and group together
- ✅ Applied recursive ownership with `-R`
- ✅ Verified ownership using `ls -l`
- ✅ Completed the ownership challenge

---

# Key Learnings

- Every file has an **owner** and a **group**.
- `chown` changes the owner of a file or directory.
- `chgrp` changes the group ownership.
- `chown owner:group file` changes both owner and group in a single command.
- `chown -R` applies ownership changes recursively to all files and subdirectories.
- `ls -l` is the easiest way to verify file ownership and permissions.

---

# Conclusion

Linux ownership is essential for securing files and controlling access in multi-user environments. Understanding `chown` and `chgrp` helps manage users, teams, and application directories effectively in real-world DevOps environments.
