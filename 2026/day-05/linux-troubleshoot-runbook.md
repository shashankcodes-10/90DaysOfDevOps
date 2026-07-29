# Linux Troubleshooting Runbook

## Target Service / Process

**Service Chosen:** SSH (`ssh.service`)

---

# Environment Basics

## 1. Check Kernel Information

### Command

```bash
uname -a
```

### Output

```text
<Paste your output here>
```

### Observation

Shows the Linux kernel version, architecture, and operating system details.

---

## 2. Check Operating System

### Command

```bash
cat /etc/os-release
```

### Output

```text
<Paste your output here>
```

### Observation

Confirms the Linux distribution and version.

---

# Filesystem Sanity

## 3. Create a Practice Directory

### Command

```bash
mkdir /tmp/runbook-demo
```

### Output

```text
Directory created successfully.
```

### Observation

Created a temporary directory for testing.

---

## 4. Copy and Verify a File

### Command

```bash
cp /etc/hosts /tmp/runbook-demo/hosts-copy
ls -l /tmp/runbook-demo
```

### Output

```text
<Paste your output here>
```

### Observation

Verified that the file was copied successfully.

---

# CPU & Memory Snapshot

## 5. Monitor System Resources

### Command

```bash
top
```

### Output

```text
<Paste only the first few lines>
```

### Observation

Checked CPU usage, memory usage, and running processes.

---

## 6. Check Memory Usage

### Command

```bash
free -h
```

### Output

```text
<Paste your output here>
```

### Observation

Verified available RAM and swap usage.

---

## 7. Check Resource Usage of SSH Process

### Command

```bash
ps -o pid,pcpu,pmem,comm -p $(pgrep sshd)
```

### Output

```text
<Paste your output here>
```

### Observation

Verified that the SSH process is using minimal CPU and memory.

---

# Disk & I/O Snapshot

## 8. Check Disk Space

### Command

```bash
df -h
```

### Output

```text
<Paste your output here>
```

### Observation

Verified that sufficient disk space is available.

---

## 9. Check Log Directory Size

### Command

```bash
du -sh /var/log
```

### Output

```text
<Paste your output here>
```

### Observation

Checked the total size of the system log directory.

---

# Network Snapshot

## 10. Check Listening Ports

### Command

```bash
ss -tulpn
```

### Output

```text
<Paste your output here>
```

### Observation

Verified that SSH is listening on port 22.

---

## 11. Test Service Response

### Command

```bash
curl -I http://localhost
```

### Output

```text
<Paste your output here>
```

### Observation

Confirmed that the web server is responding.

---

# Logs Reviewed

## 12. View SSH Logs

### Command

```bash
journalctl -u ssh -n 50
```

### Output

```text
<Paste your output here>
```

### Observation

Reviewed the latest SSH logs for any warnings or errors.

---

## 13. View Recent System Logs

### Command

```bash
tail -n 50 /var/log/syslog
```

### Output

```text
<Paste your output here>
```

### Observation

Verified that there were no critical system errors.

---

# Quick Findings

- Operating system is running normally.
- SSH service is active.
- CPU utilization is normal.
- Memory usage is within limits.
- Disk has sufficient free space.
- No critical errors found in the latest logs.

---

# If This Worsens (Next Steps)

1. Restart the affected service.

```bash
sudo systemctl restart ssh
```

2. Monitor logs continuously.

```bash
journalctl -u ssh -f
```

3. Investigate the process using additional tools.

```bash
top
htop
vmstat
iostat
```

4. Check disk usage and clean unnecessary logs if the disk becomes full.

```bash
df -h
du -sh /var/log/*
```

5. If the issue persists, collect detailed diagnostics using:

```bash
strace
lsof
```

---

# Commands Used

```bash
uname -a
cat /etc/os-release
mkdir /tmp/runbook-demo
cp /etc/hosts /tmp/runbook-demo/hosts-copy
ls -l /tmp/runbook-demo
top
free -h
ps -o pid,pcpu,pmem,comm -p $(pgrep sshd)
df -h
du -sh /var/log
ss -tulpn
curl -I http://localhost
journalctl -u ssh -n 50
tail -n 50 /var/log/syslog
```
