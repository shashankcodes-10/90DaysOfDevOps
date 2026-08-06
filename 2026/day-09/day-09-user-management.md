# Day 09 – Linux User & Group Management Challenge

## Objective

Practice Linux user and group management by creating users, assigning groups, configuring shared directories, and verifying permissions.

---

# Task 1 – Create Users

## Create Users

```bash
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor
```

## Set Passwords

```bash
sudo passwd tokyo
sudo passwd berlin
sudo passwd professor
```

## Verify Users

```bash
cat /etc/passwd | grep -E "tokyo|berlin|professor"
```

### Example Output

```text
tokyo:x:1001:1001::/home/tokyo:/bin/bash
berlin:x:1002:1002::/home/berlin:/bin/bash
professor:x:1003:1003::/home/professor:/bin/bash
```

## Verify Home Directories

```bash
ls -l /home
```

### Observation

- Successfully created three users.
- Home directories were automatically created.

---

# Task 2 – Create Groups

## Create Groups

```bash
sudo groupadd developers
sudo groupadd admins
```

## Verify Groups

```bash
cat /etc/group | grep -E "developers|admins"
```

### Example Output

```text
developers:x:1004:
admins:x:1005:
```

### Observation

Both groups were created successfully.

---

# Task 3 – Assign Users to Groups

## Add Users

```bash
sudo usermod -aG developers tokyo

sudo usermod -aG developers,admins berlin

sudo usermod -aG admins professor
```

## Verify Membership

```bash
groups tokyo

groups berlin

groups professor
```

or

```bash
id tokyo

id berlin

id professor
```

### Example Output

```text
tokyo : tokyo developers

berlin : berlin developers admins

professor : professor admins
```

### Observation

- Tokyo belongs to **developers**
- Berlin belongs to **developers** and **admins**
- Professor belongs to **admins**

---

# Task 4 – Shared Directory

## Create Directory

```bash
sudo mkdir -p /opt/dev-project
```

## Change Group Owner

```bash
sudo chgrp developers /opt/dev-project
```

## Set Permissions

```bash
sudo chmod 775 /opt/dev-project
```

## Verify Permissions

```bash
ls -ld /opt/dev-project
```

### Example Output

```text
drwxrwxr-x 2 root developers 4096 Aug 04 20:00 /opt/dev-project
```

## Test File Creation

As **tokyo**

```bash
sudo -u tokyo touch /opt/dev-project/tokyo.txt
```

As **berlin**

```bash
sudo -u berlin touch /opt/dev-project/berlin.txt
```

## Verify

```bash
ls -l /opt/dev-project
```

### Observation

Both users successfully created files inside the shared directory.

---

# Task 5 – Team Workspace

## Create User

```bash
sudo useradd -m nairobi
```

## Set Password

```bash
sudo passwd nairobi
```

---

## Create Group

```bash
sudo groupadd project-team
```

---

## Add Users

```bash
sudo usermod -aG project-team nairobi

sudo usermod -aG project-team tokyo
```

---

## Create Directory

```bash
sudo mkdir -p /opt/team-workspace
```

---

## Change Group Owner

```bash
sudo chgrp project-team /opt/team-workspace
```

---

## Set Permissions

```bash
sudo chmod 775 /opt/team-workspace
```

---

## Verify

```bash
ls -ld /opt/team-workspace
```

---

## Test

```bash
sudo -u nairobi touch /opt/team-workspace/project.txt
```

---

## Verify

```bash
ls -l /opt/team-workspace
```

### Observation

Nairobi successfully created a file inside the shared workspace.

---

# Commands Used

```bash
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor
sudo useradd -m nairobi

sudo passwd tokyo
sudo passwd berlin
sudo passwd professor
sudo passwd nairobi

sudo groupadd developers
sudo groupadd admins
sudo groupadd project-team

sudo usermod -aG developers tokyo
sudo usermod -aG developers,admins berlin
sudo usermod -aG admins professor
sudo usermod -aG project-team tokyo
sudo usermod -aG project-team nairobi

groups tokyo
groups berlin
groups professor
groups nairobi

id tokyo
id berlin
id professor
id nairobi

sudo mkdir -p /opt/dev-project
sudo mkdir -p /opt/team-workspace

sudo chgrp developers /opt/dev-project
sudo chgrp project-team /opt/team-workspace

sudo chmod 775 /opt/dev-project
sudo chmod 775 /opt/team-workspace

sudo -u tokyo touch /opt/dev-project/tokyo.txt
sudo -u berlin touch /opt/dev-project/berlin.txt
sudo -u nairobi touch /opt/team-workspace/project.txt

ls -ld /opt/dev-project
ls -ld /opt/team-workspace

ls -l /opt/dev-project
ls -l /opt/team-workspace
```

---

# Verification Checklist

- ✅ Created users: **tokyo**, **berlin**, **professor**, **nairobi**
- ✅ Created groups: **developers**, **admins**, **project-team**
- ✅ Assigned users to the correct groups
- ✅ Created shared directories
- ✅ Applied **775** permissions
- ✅ Verified users could create files in shared directories

---

# Key Learnings

- `useradd -m` creates a new user with a home directory.
- `passwd` sets a password for a user.
- `groupadd` creates a Linux group.
- `usermod -aG` adds users to supplementary groups.
- `groups` and `id` verify user group membership.
- `chgrp` changes the group ownership of a directory.
- `chmod 775` gives:
  - Owner → Read, Write, Execute
  - Group → Read, Write, Execute
  - Others → Read, Execute
- `sudo -u` is useful for testing permissions without logging in as another user.

---

# Conclusion

This exercise demonstrated how Linux manages users, groups, and permissions. Shared directories with proper group ownership allow multiple users to collaborate securely while maintaining controlled access.
