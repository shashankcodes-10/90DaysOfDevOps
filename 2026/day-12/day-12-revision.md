# Day 12 – Linux Fundamentals Revision (Days 01–11)

## Objective

Review the Linux concepts learned during Days 01–11 by revisiting key commands, practicing hands-on exercises, and identifying areas for improvement.

---

# 1. Mindset & Learning Plan

### Goal

Build a strong Linux foundation for DevOps by understanding processes, services, users, permissions, networking, and troubleshooting.

### Progress

- Completed Linux fundamentals.
- Practiced Linux commands daily.
- Improved confidence with file management, users, groups, permissions, and services.
- Ready to move towards Shell Scripting and Docker.

---

# 2. Process & Service Revision

## Check Running Processes

### Command

```bash
ps aux
```

### Observation

Displayed all running processes along with CPU and memory usage.

---

## Check SSH Service

### Command

```bash
systemctl status ssh
```

### Observation

Verified that the SSH service is active and running.

---

## View SSH Logs

### Command

```bash
journalctl -u ssh -n 20
```

### Observation

Reviewed recent SSH logs and confirmed there were no critical errors.

---

# 3. File Operations Revision

## Create Directory

```bash
mkdir revision-demo
```

---

## Create File

```bash
touch notes.txt
```

---

## Append Content

```bash
echo "Linux Revision Day" >> notes.txt
```

---

## Check Permissions

```bash
ls -l notes.txt
```

---

## Copy File

```bash
cp notes.txt backup.txt
```

---

## Change Permissions

```bash
chmod 755 backup.txt
```

### Observation

Successfully created, copied, and modified file permissions.

---

# 4. Cheat Sheet Refresh

## Five Commands I Would Use First During an Incident

| Command | Why |
|---------|-----|
| `ps aux` | Check running processes. |
| `top` | Monitor CPU and memory usage. |
| `systemctl status <service>` | Verify service health. |
| `journalctl -u <service>` | Review service logs. |
| `df -h` | Check available disk space. |

---

# 5. User & Group Revision

## Check User Information

```bash
id tokyo
```

---

## Check Groups

```bash
groups tokyo
```

---

## Verify Ownership

```bash
ls -l
```

### Observation

Verified user membership and file ownership successfully.

---

# Mini Self-Check

## 1. Which three commands save you the most time?

### Answer

- `ps aux` – Quickly checks running processes.
- `systemctl status` – Verifies whether a service is running.
- `journalctl -u` – Displays service logs for troubleshooting.

---

## 2. How do you check if a service is healthy?

### Commands

```bash
systemctl status <service>

journalctl -u <service> -n 50

ps aux | grep <service>
```

---

## 3. How do you safely change ownership and permissions?

### Example

```bash
sudo chown tokyo:developers file.txt

chmod 755 file.txt
```

---

## 4. What will you improve in the next three days?

- Practice Bash scripting.
- Improve Linux troubleshooting.
- Learn more text-processing commands (`grep`, `awk`, `sed`, and `find`).

---

# Commands Practiced

```bash
ps aux

top

systemctl status ssh

journalctl -u ssh -n 20

mkdir revision-demo

touch notes.txt

echo "Linux Revision Day" >> notes.txt

cp notes.txt backup.txt

ls -l

chmod 755 backup.txt

id tokyo

groups tokyo

df -h
```

---

# Key Takeaways

- Linux command-line skills improve with regular practice.
- Service troubleshooting always begins with checking status and logs.
- File permissions and ownership are critical for system security.
- User and group management help organize secure access.
- A strong understanding of Linux fundamentals is essential before learning Docker, Kubernetes, and Cloud technologies.

---

# Week 1 Summary

## Topics Covered

- Linux Architecture
- Processes and Services
- Linux Commands
- Troubleshooting Basics
- File Input & Output
- Linux File System Hierarchy
- Cloud Server Setup
- User & Group Management
- File Permissions
- File Ownership

---

# Conclusion

The first twelve days established a strong foundation in Linux administration. I am now comfortable with navigating the file system, managing users and groups, handling permissions, monitoring services, troubleshooting common issues, and performing basic system administration tasks. This knowledge will support the next phase of the DevOps roadmap, including Shell Scripting, Docker, and Kubernetes.
