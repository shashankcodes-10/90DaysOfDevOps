# Day 28 – DevOps Revision: Days 01–27

> **90 Days of DevOps – Personal Revision Reference**
>
> This file is a consolidated command and theory reference from the topics practiced across Days 01–27.
>
> **Purpose:** quick revision before hands-on practice, troubleshooting, interviews, and real DevOps work.

---

# 1. DevOps & Cloud Fundamentals – Day 01

## What is DevOps?

DevOps is a combination of practices, culture, automation, and tools that helps development and operations teams deliver software faster and more reliably.

### Core DevOps lifecycle

```text
Plan
  ↓
Code
  ↓
Build
  ↓
Test
  ↓
Release
  ↓
Deploy
  ↓
Operate
  ↓
Monitor
  ↺
```

### Important DevOps concepts

- Version Control – Git/GitHub
- CI – Continuous Integration
- CD – Continuous Delivery / Deployment
- Infrastructure as Code – Terraform
- Containers – Docker
- Container orchestration – Kubernetes
- Configuration management – Ansible
- Monitoring – Prometheus / Grafana
- Cloud – AWS / Azure / OCI
- Automation – Shell / Python

---

# 2. Linux Fundamentals – Days 02–07

# Linux Architecture

A simplified Linux stack:

```text
Users
  ↓
Applications / Shell
  ↓
System Libraries
  ↓
Linux Kernel
  ↓
Hardware
```

The kernel manages:

- CPU
- Memory
- Processes
- Filesystems
- Networking
- Devices

---

# 3. Linux Navigation Commands

## Current directory

```bash
pwd
```

Shows the current working directory.

## List files

```bash
ls
ls -l
ls -la
ls -lh
```

Useful variations:

```bash
ls -la
```

Shows hidden files as well.

## Change directory

```bash
cd /path
cd ..
cd ~
cd -
```

## Create directory

```bash
mkdir directory
mkdir -p parent/child
```

## Create file

```bash
touch file.txt
```

## Copy

```bash
cp source.txt destination.txt
cp -r source_dir destination_dir
```

## Move / Rename

```bash
mv old.txt new.txt
mv file.txt /tmp/
```

## Delete file

```bash
rm file.txt
```

## Delete directory

```bash
rm -r directory
```

Be careful with:

```bash
rm -rf directory
```

---

# 4. Reading Files

## `cat`

```bash
cat file.txt
```

Read the complete file.

## `less`

```bash
less file.txt
```

Read large files interactively.

## `head`

```bash
head file.txt
head -n 5 file.txt
```

Shows the first lines.

## `tail`

```bash
tail file.txt
tail -n 5 file.txt
tail -f app.log
```

Shows the last lines and can follow a changing log.

## `wc`

```bash
wc -l file.txt
wc -w file.txt
wc -c file.txt
```

Counts lines, words, and characters.

---

# 5. File Creation and Redirection – Day 06

Create an empty file:

```bash
touch notes.txt
```

Write/overwrite:

```bash
echo "Line 1" > notes.txt
```

Append:

```bash
echo "Line 2" >> notes.txt
```

Write and display:

```bash
echo "Line 3" | tee -a notes.txt
```

Read:

```bash
cat notes.txt
```

---

# 6. Linux File System Hierarchy – Day 07

| Directory | Purpose |
|---|---|
| `/` | Root of the entire filesystem |
| `/home` | Normal users' home directories |
| `/root` | Root user's home directory |
| `/etc` | System/application configuration |
| `/var` | Variable data |
| `/var/log` | System/application logs |
| `/tmp` | Temporary files |
| `/bin` | Essential binaries |
| `/usr/bin` | User command binaries |
| `/opt` | Optional/third-party applications |

Useful commands:

```bash
ls -la ~
ls -l /etc
ls -l /var/log
cat /etc/hostname
```

Find large logs:

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
```

---

# 7. Processes – Days 04–05

## List processes

```bash
ps
ps aux
```

## Live process monitoring

```bash
top
```

On Linux, `htop` can also be used if installed:

```bash
htop
```

## Find a process

```bash
pgrep nginx
```

## Process details

```bash
ps -o pid,pcpu,pmem,comm -p <PID>
```

## Kill a process

```bash
kill <PID>
```

Force kill only when necessary:

```bash
kill -9 <PID>
```

## Background process

```bash
command &
```

Useful shell job commands:

```bash
jobs
fg
bg
```

---

# 8. Services / systemd – Days 04–05 & 07

Check service status:

```bash
systemctl status nginx
```

Start:

```bash
sudo systemctl start nginx
```

Stop:

```bash
sudo systemctl stop nginx
```

Restart:

```bash
sudo systemctl restart nginx
```

Enable at boot:

```bash
sudo systemctl enable nginx
```

Disable at boot:

```bash
sudo systemctl disable nginx
```

Check whether enabled:

```bash
systemctl is-enabled nginx
```

List services:

```bash
systemctl list-units --type=service
```

---

# 9. Logs

For systemd services:

```bash
journalctl -u nginx
```

Last 50 lines:

```bash
journalctl -u nginx -n 50
```

Follow logs:

```bash
journalctl -u nginx -f
```

Traditional log following:

```bash
tail -n 50 /var/log/<file>.log
tail -f /var/log/<file>.log
```

### Basic troubleshooting flow

```text
Service issue
    ↓
systemctl status <service>
    ↓
journalctl -u <service> -n 50
    ↓
Check process
    ↓
Check CPU / memory / disk
    ↓
Check network
    ↓
Restart only when appropriate
    ↓
Verify again
```

---

# 10. CPU, Memory, Disk – Day 05

CPU/processes:

```bash
top
ps aux --sort=-%cpu | head -10
```

Memory on Linux:

```bash
free -h
```

On macOS:

```bash
vm_stat
```

Disk space:

```bash
df -h
```

Directory size:

```bash
du -sh /var/log
du -sh *
```

I/O:

```bash
iostat
vmstat
```

---

# 11. Networking Fundamentals – Days 14–15

## Host/IP information

Linux:

```bash
ip addr show
```

Get local addresses:

```bash
hostname -I
```

On macOS, depending on the interface:

```bash
ifconfig
```

## Reachability

```bash
ping google.com
```

## Route/path

```bash
traceroute google.com
```

## DNS

```bash
dig google.com
```

```bash
nslookup google.com
```

## HTTP check

```bash
curl -I https://example.com
```

## Port connections

Linux:

```bash
ss -tulpn
```

Alternative:

```bash
netstat -tulpn
```

Connection snapshot:

```bash
netstat -an | head
```

## Port probe

```bash
nc -zv localhost 8080
```

---

# 12. Networking Concepts

## OSI Model

```text
L7 Application
L6 Presentation
L5 Session
L4 Transport
L3 Network
L2 Data Link
L1 Physical
```

## TCP/IP model

```text
Application
Transport
Internet
Link
```

### Important protocol placement

```text
HTTP / HTTPS / DNS → Application
TCP / UDP           → Transport
IP                  → Internet / Network
Ethernet            → Link / Data Link
```

Example:

```text
curl https://example.com
        ↓
HTTP
        ↓
TCP
        ↓
IP
        ↓
Network interface
```

---

# 13. DNS

Common records:

| Record | Meaning |
|---|---|
| A | IPv4 address |
| AAAA | IPv6 address |
| CNAME | Alias to another hostname |
| MX | Mail server |
| NS | Authoritative nameserver |

Basic check:

```bash
dig google.com
```

---

# 14. IP Addressing

Example:

```text
192.168.1.10
```

IPv4 contains four octets.

Private ranges:

```text
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

Public IPs are routable over the public Internet.

---

# 15. CIDR & Subnetting

Example:

```text
192.168.1.0/24
```

`/24` means the first 24 bits represent the network portion.

| CIDR | Mask | Total IPs | Typical usable hosts |
|---|---|---:|---:|
| `/24` | 255.255.255.0 | 256 | 254 |
| `/16` | 255.255.0.0 | 65,536 | 65,534 |
| `/28` | 255.255.255.240 | 16 | 14 |

Subnetting helps divide a network into smaller logical networks.

---

# 16. Common Ports

| Port | Service |
|---:|---|
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 53 | DNS |
| 3306 | MySQL |
| 6379 | Redis |
| 27017 | MongoDB |

---

# 17. Cloud Server & Web Deployment – Day 08

Typical workflow:

```text
Launch EC2/Utho server
        ↓
Configure security group
        ↓
SSH into server
        ↓
Update packages
        ↓
Install Docker / Nginx
        ↓
Start service
        ↓
Open port 80
        ↓
Test from browser
        ↓
Collect logs
```

SSH example:

```bash
ssh -i key.pem ubuntu@<server-ip>
```

Copy a file from server:

```bash
scp -i key.pem ubuntu@<server-ip>:~/nginx-logs.txt .
```

Nginx service:

```bash
sudo systemctl status nginx
```

Nginx logs commonly include:

```text
/var/log/nginx/access.log
/var/log/nginx/error.log
```

---

# 18. Users & Groups – Day 09

Create user with home directory:

```bash
sudo useradd -m tokyo
```

Set password:

```bash
sudo passwd tokyo
```

Create group:

```bash
sudo groupadd developers
```

Add user to group:

```bash
sudo usermod -aG developers tokyo
```

Add to multiple groups:

```bash
sudo usermod -aG developers,admins berlin
```

Check user identity/groups:

```bash
id tokyo
groups tokyo
```

Check users:

```bash
cat /etc/passwd
ls -la /home
```

Check groups:

```bash
cat /etc/group
```

Run a command as another user:

```bash
sudo -u tokyo command
```

---

# 19. File Permissions – Day 10

Permission format:

```text
rwxrwxrwx
│  │  │
│  │  └── others
│  └───── group
└──────── owner
```

Values:

```text
r = 4
w = 2
x = 1
```

Example:

```text
755
```

Means:

```text
owner  = rwx = 7
group  = r-x = 5
others = r-x = 5
```

Check permissions:

```bash
ls -l
```

Make executable:

```bash
chmod +x script.sh
```

Numeric permissions:

```bash
chmod 755 script.sh
chmod 640 notes.txt
```

Remove write permission:

```bash
chmod -w file.txt
```

Create directory:

```bash
mkdir project
chmod 755 project
```

---

# 20. Ownership – Day 11

Check ownership:

```bash
ls -l file.txt
```

Change owner:

```bash
sudo chown tokyo file.txt
```

Change group:

```bash
sudo chgrp heist-team file.txt
```

Change both:

```bash
sudo chown professor:heist-team project-config.yaml
```

Recursive ownership:

```bash
sudo chown -R professor:planners heist-project/
```

---

# 21. LVM – Day 13

## LVM architecture

```text
Physical Disk
     ↓
Physical Volume (PV)
     ↓
Volume Group (VG)
     ↓
Logical Volume (LV)
     ↓
Filesystem
     ↓
Mount Point
```

Check storage:

```bash
lsblk
pvs
vgs
lvs
df -h
```

Create physical volume:

```bash
sudo pvcreate /dev/sdb
```

Create volume group:

```bash
sudo vgcreate devops-vg /dev/sdb
```

Create logical volume:

```bash
sudo lvcreate -L 500M -n app-data devops-vg
```

Format:

```bash
sudo mkfs.ext4 /dev/devops-vg/app-data
```

Create mount point:

```bash
sudo mkdir -p /mnt/app-data
```

Mount:

```bash
sudo mount /dev/devops-vg/app-data /mnt/app-data
```

Check:

```bash
df -h /mnt/app-data
```

Extend LV:

```bash
sudo lvextend -L +200M /dev/devops-vg/app-data
```

Extend and resize filesystem together where supported:

```bash
sudo lvextend -r -L +200M /dev/devops-vg/app-data
```

For ext4, filesystem resize can also be done with:

```bash
sudo resize2fs /dev/devops-vg/app-data
```

### Important

LVM commands can destroy or overwrite storage if used incorrectly. Always verify the target device with:

```bash
lsblk
```

before running storage-changing commands.

---

# 22. Shell Scripting Basics – Day 16

Basic script:

```bash
#!/bin/bash

echo "Hello, DevOps!"
```

Make executable:

```bash
chmod +x hello.sh
```

Run:

```bash
./hello.sh
```

Variables:

```bash
NAME="Shashank"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
```

Input:

```bash
read -p "Enter name: " NAME
echo "Hello $NAME"
```

Condition:

```bash
if [ "$NUMBER" -gt 0 ]; then
    echo "Positive"
elif [ "$NUMBER" -lt 0 ]; then
    echo "Negative"
else
    echo "Zero"
fi
```

File check:

```bash
if [ -f "$FILE" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
```

---

# 23. Shell Loops & Arguments – Day 17

For loop:

```bash
for fruit in apple banana mango orange grape; do
    echo "$fruit"
done
```

Count:

```bash
for i in {1..10}; do
    echo "$i"
done
```

While:

```bash
COUNT=5

while [ "$COUNT" -ge 0 ]; do
    echo "$COUNT"
    COUNT=$((COUNT - 1))
done
```

Arguments:

```bash
echo "$0"
echo "$1"
echo "$#"
echo "$@"
```

Check root:

```bash
if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi
```

Package checking on Debian/Ubuntu:

```bash
dpkg -s curl
```

---

# 24. Shell Functions & Strict Mode – Day 18

Function:

```bash
greet() {
    echo "Hello, $1!"
}

greet "Shashank"
```

Addition:

```bash
add() {
    echo $(( $1 + $2 ))
}

add 10 20
```

Local variable:

```bash
demo() {
    local MESSAGE="Hello"
    echo "$MESSAGE"
}
```

Strict mode:

```bash
set -euo pipefail
```

Meaning:

```text
-e          Exit when a command fails
-u          Error on unset variables
pipefail    Catch failures inside pipelines
```

Debug:

```bash
set -x
```

Exit status:

```bash
echo $?
```

---

# 25. Shell Text Processing – Days 19–21

## grep

```bash
grep "ERROR" app.log
grep -i "error" app.log
grep -n "ERROR" app.log
grep -c "ERROR" app.log
grep -r "ERROR" /var/log
grep -v "INFO" app.log
grep -E "ERROR|Failed" app.log
```

## awk

First column:

```bash
awk '{print $1}' file.txt
```

Multiple columns:

```bash
awk '{print $1, $3}' file.txt
```

Colon-separated:

```bash
awk -F: '{print $1}' /etc/passwd
```

## sed

Replace:

```bash
sed 's/old/new/g' file.txt
```

Delete matching lines:

```bash
sed '/ERROR/d' file.txt
```

## cut

```bash
cut -d: -f1 /etc/passwd
```

## sort

```bash
sort file.txt
sort -n numbers.txt
sort -r file.txt
sort -u file.txt
```

## uniq

```bash
uniq file.txt
uniq -c file.txt
```

## tr

```bash
echo "hello" | tr 'a-z' 'A-Z'
```

## head/tail

```bash
head -n 5 file.txt
tail -n 5 file.txt
tail -f app.log
```

---

# 26. Log Rotation & Backup – Day 19

Find old logs:

```bash
find /path -name "*.log" -mtime +7
```

Compress:

```bash
find /path -name "*.log" -mtime +7 -exec gzip {} \;
```

Delete old compressed logs:

```bash
find /path -name "*.gz" -mtime +30 -delete
```

Create timestamp:

```bash
date +%Y-%m-%d
```

Create backup:

```bash
tar -czf backup.tar.gz /source/dir
```

Check archive:

```bash
ls -lh backup.tar.gz
```

---

# 27. Crontab – Day 19

View cron jobs:

```bash
crontab -l
```

Edit:

```bash
crontab -e
```

Cron format:

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week
│ │ │ └──── Month
│ │ └────── Day of month
│ └──────── Hour
└────────── Minute
```

Every day at 2 AM:

```cron
0 2 * * * /path/to/log_rotate.sh
```

Every Sunday at 3 AM:

```cron
0 3 * * 0 /path/to/backup.sh
```

Every 5 minutes:

```cron
*/5 * * * * /path/to/health_check.sh
```

---

# 28. Log Analyzer – Day 20

Count errors:

```bash
grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l
```

Critical events with line numbers:

```bash
grep -n "CRITICAL" "$LOG_FILE"
```

Top error messages:

```bash
grep "ERROR" app.log |
awk '{$1=$2=$3=""; print}' |
sort |
uniq -c |
sort -rn |
head -5
```

Generate report:

```bash
DATE=$(date +%Y-%m-%d)
REPORT="log_report_${DATE}.txt"
```

Redirect output:

```bash
cat > "$REPORT" << EOF
Log Analysis Report
===================
EOF
```

---

# 29. Git Fundamentals – Day 22

## Check Git

```bash
git --version
```

Configure identity:

```bash
git config --global user.name "shashank"
git config --global user.email "your-email@example.com"
```

View configuration:

```bash
git config --list
```

Initialize repository:

```bash
git init
```

Check status:

```bash
git status
```

Stage:

```bash
git add file.txt
git add .
```

Commit:

```bash
git commit -m "meaningful message"
```

View history:

```bash
git log
git log --oneline
```

Compact graph:

```bash
git log --oneline --graph --all
```

View changes:

```bash
git diff
```

---

# 30. Git Working Areas

Git can be understood as three main areas:

```text
Working Directory
       ↓ git add
Staging Area
       ↓ git commit
Repository
```

### Working directory

Files currently being edited.

### Staging area

Changes selected for the next commit.

### Repository

Committed Git history stored in `.git`.

---

# 31. Git Branching – Days 23–24

List branches:

```bash
git branch
```

Create branch:

```bash
git branch feature-login
```

Create and switch:

```bash
git checkout -b feature-login
```

Modern switch:

```bash
git switch feature-login
```

Create and switch using switch:

```bash
git switch -c feature-login
```

Switch back:

```bash
git checkout master
```

Delete local branch:

```bash
git branch -d feature-login
```

---

# 32. Git Remote & GitHub

Check remotes:

```bash
git remote -v
```

Add remote:

```bash
git remote add origin git@github.com:username/repo.git
```

Push branch:

```bash
git push origin master
```

Push main:

```bash
git push origin main
```

Push branch and set upstream:

```bash
git push -u origin feature-1
```

Pull:

```bash
git pull origin master
```

Fetch:

```bash
git fetch origin master
```

Merge fetched branch:

```bash
git merge origin/master
```

---

# 33. SSH for GitHub

Generate SSH key:

```bash
ssh-keygen
```

List SSH files:

```bash
ls -la ~/.ssh
```

View public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

The public key can be added to GitHub SSH settings.

---

# 34. Clone vs Fork

### Clone

Downloads a repository to the local machine.

```bash
git clone <repository-url>
```

### Fork

Creates your own GitHub copy of another repository.

Typical flow:

```text
Original Repository
        ↓
      Fork
        ↓
Your GitHub Repository
        ↓
      Clone
        ↓
Local Machine
```

---

# 35. Merge – Day 24

Merge a branch:

```bash
git checkout master
git merge feature-login
```

### Fast-forward

If the target branch has not moved forward independently, Git can simply move its pointer forward.

```text
A---B---C
        ↑
     feature

A---B---C
        ↑
      main
```

### Merge commit

If both branches have independent commits, Git may create a merge commit.

```text
      C---D
     /     \
A---B       M
     \     /
      E---F
```

---

# 36. Merge Conflicts

A conflict can happen when both branches change the same part of a file.

Check:

```bash
git status
```

Edit the conflicted file and remove markers:

```text
<<<<<<< HEAD
current branch
=======
incoming branch
>>>>>>> feature
```

Then:

```bash
git add .
git commit -m "resolved conflict"
```

---

# 37. Git Rebase – Day 24

Create branch:

```bash
git checkout -b feature-dashboard
```

Rebase onto master:

```bash
git rebase master
```

Visualize:

```bash
git log --oneline --graph --all
```

### Rebase concept

Rebase moves/replays commits onto a new base.

It can produce a cleaner linear history.

### Important warning

Avoid rebasing commits that have already been pushed and shared with other developers unless the team explicitly agrees, because rebase rewrites commit history.

---

# 38. Squash Merge

Squash:

```bash
git merge feature-profile --squash
```

Then create the actual commit:

```bash
git commit -m "add profile feature"
```

A squash combines multiple feature commits into one change on the target branch.

---

# 39. Git Stash – Day 24

Save uncommitted work:

```bash
git stash
```

List stashes:

```bash
git stash list
```

Apply and remove stash:

```bash
git stash pop
```

Apply without removing:

```bash
git stash apply
```

Specific stash:

```bash
git stash pop stash@{0}
```

Stash with message:

```bash
git stash push -m "work in progress"
```

### `pop` vs `apply`

```text
apply → applies stash and keeps it
pop   → applies stash and removes it if successful
```

---

# 40. Git Cherry-Pick – Day 24

View commits:

```bash
git log --oneline
```

Apply a specific commit:

```bash
git cherry-pick <commit-hash>
```

If conflict occurs:

```bash
git status
```

Resolve files:

```bash
git add .
git cherry-pick --continue
```

Abort:

```bash
git cherry-pick --abort
```

Skip:

```bash
git cherry-pick --skip
```

### Use case

Cherry-pick is useful when one specific fix/commit is needed on another branch without merging the entire branch.

---

# 41. Git Reset – Day 25

View history:

```bash
git log --oneline
```

## Soft reset

```bash
git reset --soft <commit>
```

Moves HEAD but keeps changes staged.

## Mixed reset

```bash
git reset --mixed <commit>
```

Moves HEAD and unstages changes while keeping working-directory changes.

This is the default reset mode:

```bash
git reset <commit>
```

## Hard reset

```bash
git reset --hard <commit>
```

Moves HEAD and discards tracked working/staging changes.

### Important

`--hard` is destructive if you have changes that are not safely stored elsewhere.

---

# 42. Git Revert – Day 25

Revert a commit:

```bash
git revert <commit-hash>
```

Unlike reset, revert creates a new commit that reverses an earlier commit.

### Reset vs Revert

| | `git reset` | `git revert` |
|---|---|---|
| Main purpose | Move branch pointer | Undo a commit with a new commit |
| History | Can rewrite it | Preserves history |
| Shared branch | Risky | Safer |
| Typical use | Local/unpublished work | Shared/pushed work |

---

# 43. Git Reflog

Safety net for local Git history:

```bash
git reflog
```

It can help find previous HEAD positions after operations such as reset.

---

# 44. Branching Strategies – Day 25

## GitFlow

Typical branches:

```text
main
develop
feature/*
release/*
hotfix/*
```

Useful for teams with structured release cycles.

## GitHub Flow

Simple model:

```text
main
 ↓
feature branch
 ↓
Pull Request
 ↓
review
 ↓
merge
```

Useful for teams deploying frequently.

## Trunk-Based Development

Developers work around a shared main/trunk with short-lived branches and frequent integration.

---

# 45. GitHub CLI – Day 26

Check version:

```bash
gh --version
```

Authenticate:

```bash
gh auth login
```

Check authentication:

```bash
gh auth status
```

Create repository:

```bash
gh repo create
```

Clone:

```bash
gh repo clone owner/repo
```

View repository:

```bash
gh repo view
```

List repositories:

```bash
gh repo list
```

Open repository in browser:

```bash
gh repo view --web
```

Delete repository:

```bash
gh repo delete owner/repo
```

---

# 46. GitHub Issues with `gh`

Create issue:

```bash
gh issue create
```

List issues:

```bash
gh issue list
```

View issue:

```bash
gh issue view <number>
```

Close issue:

```bash
gh issue close <number>
```

---

# 47. GitHub Pull Requests with `gh`

Create PR:

```bash
gh pr create
```

Auto-fill from commits:

```bash
gh pr create --fill
```

List PRs:

```bash
gh pr list
```

View PR:

```bash
gh pr view <number>
```

Merge PR:

```bash
gh pr merge <number>
```

---

# 48. GitHub Actions with `gh`

List workflow runs:

```bash
gh run list
```

View a run:

```bash
gh run view <run-id>
```

List workflows:

```bash
gh workflow list
```

Run workflow manually when supported:

```bash
gh workflow run <workflow>
```

---

# 49. Useful GitHub CLI Tools

API request:

```bash
gh api <endpoint>
```

Gist:

```bash
gh gist create file.txt
```

Releases:

```bash
gh release list
```

Search repositories:

```bash
gh search repos "devops"
```

Aliases:

```bash
gh alias list
```

---

# 50. Important Git Command Groups

## Setup

```bash
git --version
git config --list
git config --global user.name "name"
git config --global user.email "email"
```

## Daily workflow

```bash
git status
git add .
git commit -m "message"
git diff
git log --oneline
```

## Branching

```bash
git branch
git checkout -b feature
git switch feature
git switch -c feature
```

## Remote

```bash
git remote -v
git push
git pull
git fetch
git clone
```

## Integration

```bash
git merge
git rebase
git cherry-pick
```

## Temporary work

```bash
git stash
git stash list
git stash pop
git stash apply
```

## Undo

```bash
git reset --soft
git reset --mixed
git reset --hard
git revert
git reflog
```

---

# 51. DevOps Troubleshooting Cheat Sheet

## Service is down

```bash
systemctl status <service>
journalctl -u <service> -n 50
ps aux | grep <service>
```

## CPU is high

```bash
top
ps aux --sort=-%cpu | head -10
```

## Memory is high

```bash
free -h
ps aux --sort=-%mem | head -10
```

On macOS:

```bash
vm_stat
```

## Disk is full

```bash
df -h
du -sh *
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
```

## Port is not reachable

```bash
ss -tulpn
nc -zv localhost 8080
curl -I http://localhost:8080
```

## DNS problem

```bash
dig example.com
nslookup example.com
```

## Network reachability

```bash
ping example.com
traceroute example.com
```

## Check HTTP response

```bash
curl -I https://example.com
```

---

# 52. Common Text-Processing Pipeline

A very important Linux pattern is:

```text
command
  ↓
grep
  ↓
awk
  ↓
sort
  ↓
uniq
  ↓
head
```

Example:

```bash
grep "ERROR" app.log |
awk '{print $NF}' |
sort |
uniq -c |
sort -rn |
head -5
```

This is the foundation of many log-analysis commands.

---

# 53. Common File / Permission Workflow

```text
Create
  ↓
ls -l
  ↓
chmod
  ↓
chown / chgrp
  ↓
Test
  ↓
Verify
```

Example:

```bash
touch script.sh
chmod +x script.sh
sudo chown user:group script.sh
ls -l script.sh
./script.sh
```

---

# 54. Common Git Incident Workflow

If a change is wrong:

```bash
git status
git log --oneline
git diff
```

If the change is local and unpublished:

```bash
git reset --soft HEAD~1
```

If a pushed/shared commit needs to be undone:

```bash
git revert <commit>
```

If work needs to be temporarily saved:

```bash
git stash
```

If one specific fix is needed:

```bash
git cherry-pick <commit>
```

If something seems lost:

```bash
git reflog
```

---

# 55. Quick-Fire Answers

## 1. What does `chmod 755 script.sh` do?

It gives the owner read/write/execute permissions and gives group and others read/execute permissions.

```text
Owner  = 7 = rwx
Group  = 5 = r-x
Others = 5 = r-x
```

---

## 2. Process vs Service

A **process** is a running instance of a program.

A **service** is usually a long-running background application managed by an init/service manager such as systemd.

---

## 3. Find which process uses port 8080

On Linux:

```bash
ss -tulpn | grep :8080
```

Depending on the system, another option is:

```bash
lsof -i :8080
```

---

## 4. What does `set -euo pipefail` do?

```text
-e        stop on command errors
-u        error on unset variables
pipefail  detect failures inside pipelines
```

---

## 5. `git reset --hard` vs `git revert`

```text
reset --hard → moves history and discards tracked local changes
revert       → creates a new commit that reverses an earlier commit
```

Revert is generally safer for shared branches.

---

## 6. Strategy for a small team shipping weekly

A simple GitHub Flow-style workflow is a practical choice:

```text
main
 ↓
short-lived feature branch
 ↓
Pull Request
 ↓
Review
 ↓
Merge
```

---

## 7. What does `git stash` do?

It temporarily stores uncommitted working changes so the working tree can be cleaned up and you can switch context.

```bash
git stash
git stash pop
```

---

## 8. Schedule a script every day at 3 AM

```cron
0 3 * * * /path/to/script.sh
```

---

## 9. `git fetch` vs `git pull`

```text
git fetch → downloads remote changes without merging them
git pull  → fetches and then integrates the changes
```

---

## 10. What is LVM?

LVM is Logical Volume Management. It provides a flexible storage layer using:

```text
PV → VG → LV → Filesystem → Mount Point
```

It makes operations such as extending logical volumes more flexible than managing fixed partitions directly.

---

# 56. Interview-Level Explanations

## Git Branch

A branch is a movable pointer to a commit that allows development to happen independently.

```text
main
 |
 A---B
      \
       C---D
           ↑
       feature
```

---

## Merge vs Rebase

### Merge

Preserves the branch structure and can create a merge commit.

### Rebase

Replays commits on top of another base and can produce a cleaner linear history.

```text
Merge:
      C
     / \
A---B   M
     \ /
      D

Rebase:
A---B---C'---D'
```

---

## Reset vs Revert

```text
Reset:
Move branch pointer

Revert:
Create a new commit that undoes an old commit
```

Use extra caution with reset on shared branches.

---

## Stash

```text
Working changes
      ↓
   git stash
      ↓
Clean working tree
      ↓
Switch / fix / update
      ↓
git stash pop
```

---

# 57. Personal Hands-On Command List

These are the commands I have repeatedly practiced during the 90 Days of DevOps exercises.

```bash
# Linux
pwd
ls
ls -la
cd
mkdir
mkdir -p
touch
cp
mv
rm
cat
head
tail
less
wc
find
du
df

# Processes
ps
ps aux
top
pgrep
kill
jobs
fg
bg

# Services
systemctl status
systemctl start
systemctl stop
systemctl restart
systemctl enable
systemctl is-enabled
systemctl list-units

# Logs
journalctl
journalctl -u
tail -f

# Users / Groups
useradd
passwd
usermod
groupadd
groups
id
sudo -u

# Permissions
ls -l
chmod
chown
chgrp

# LVM
lsblk
pvs
vgs
lvs
pvcreate
vgcreate
lvcreate
lvextend
mkfs
mount
resize2fs

# Networking
ping
hostname -I
ip addr
traceroute
dig
nslookup
curl
ss
netstat
nc

# Shell scripting
echo
read
if
elif
else
case
for
while
until
function
return
local
set
trap

# Text processing
grep
awk
sed
cut
sort
uniq
tr
wc
head
tail

# Automation
find
gzip
tar
crontab

# Git
git --version
git config
git init
git status
git add
git commit
git log
git diff
git branch
git checkout
git switch
git remote
git push
git pull
git fetch
git clone
git merge
git rebase
git stash
git cherry-pick
git reset
git revert
git reflog

# GitHub CLI
gh --version
gh auth login
gh auth status
gh repo create
gh repo clone
gh repo view
gh repo list
gh issue create
gh issue list
gh issue view
gh issue close
gh pr create
gh pr list
gh pr view
gh pr merge
gh run list
gh run view
gh workflow list
gh api
gh gist
gh release
gh alias
gh search repos
```

---

# 58. The Commands I Would Reach for First During an Incident

If a production application is reported as down, I would not randomly run commands. I would follow a structured flow.

```text
1. Is the server reachable?
       ↓
2. Is the service running?
       ↓
3. What do the logs say?
       ↓
4. Is CPU/memory/disk healthy?
       ↓
5. Is the required port listening?
       ↓
6. Can the service communicate over the network?
       ↓
7. What changed recently?
       ↓
8. Apply the safest fix
       ↓
9. Verify recovery
```

First commands might be:

```bash
ping <host>
systemctl status <service>
journalctl -u <service> -n 50
top
df -h
ss -tulpn
curl -I <endpoint>
```

---

# 59. Important Linux Philosophy

Linux troubleshooting is usually about combining small tools.

Instead of looking for one giant command:

```text
inspect
  ↓
filter
  ↓
extract
  ↓
sort
  ↓
count
  ↓
interpret
```

Example:

```bash
grep "ERROR" app.log | sort | uniq -c | sort -rn | head
```

The power comes from combining commands.

---

# 60. Final Revision Checklist

## Linux

- [ ] File navigation
- [ ] File operations
- [ ] Process management
- [ ] systemd services
- [ ] Logs
- [ ] CPU / memory / disk
- [ ] File hierarchy
- [ ] Users / groups
- [ ] Permissions
- [ ] Ownership
- [ ] LVM
- [ ] Networking
- [ ] DNS
- [ ] IP / CIDR / ports

## Shell Scripting

- [ ] Shebang
- [ ] Variables
- [ ] `read`
- [ ] Arguments
- [ ] Conditions
- [ ] Loops
- [ ] Functions
- [ ] `grep`
- [ ] `awk`
- [ ] `sed`
- [ ] `find`
- [ ] `sort`
- [ ] `uniq`
- [ ] Error handling
- [ ] `set -euo pipefail`
- [ ] `trap`
- [ ] Cron
- [ ] Log analysis
- [ ] Backup automation

## Git & GitHub

- [ ] init
- [ ] add
- [ ] commit
- [ ] status
- [ ] diff
- [ ] log
- [ ] branches
- [ ] remote
- [ ] push
- [ ] pull
- [ ] fetch
- [ ] clone
- [ ] fork
- [ ] merge
- [ ] rebase
- [ ] squash
- [ ] stash
- [ ] cherry-pick
- [ ] reset
- [ ] revert
- [ ] reflog
- [ ] GitFlow
- [ ] GitHub Flow
- [ ] Trunk-Based Development
- [ ] GitHub CLI

---

# 61. My Day 28 Revision Goal

The goal is not to memorize hundreds of commands.

The goal is to be able to:

```text
Understand the problem
       ↓
Choose the right command
       ↓
Read the output
       ↓
Identify the next check
       ↓
Fix the issue safely
       ↓
Verify the result
```

That is the real command-line skill I want to build as a DevOps engineer.

---

# 62. Learn in Public

> 28 days completed. Today I revised my DevOps journey from Linux and networking to Shell Scripting, Git, GitHub, LVM, and GitHub CLI.
>
> The focus is no longer just remembering commands — it is understanding **which command to use, why to use it, and how to troubleshoot from the output.**

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
