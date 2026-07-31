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
Linux ip-172-31-22-115 7.0.0-1006-aws #6-Ubuntu SMP PREEMPT Tue May 26 12:04:34 UTC 2026 x86_64 GNU/Linux
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
PRETTY_NAME="Ubuntu 26.04 LTS"
NAME="Ubuntu"
VERSION_ID="26.04"
VERSION="26.04 LTS (Resolute Raccoon)"
VERSION_CODENAME=resolute
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=resolute
LOGO=ubuntu-logo
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
-
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
total 4
-rw-r--r-- 1 ubuntu ubuntu 221 Jul 31 10:02 hosts-copy
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
top - 10:03:58 up 9 min,  1 user,  load average: 0.04, 0.01, 0.00
Tasks: 116 total,   1 running, 115 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni, 99.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.2 st
MiB Mem :    908.7 total,    382.1 free,    301.4 used,    334.4 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.    607.3 avail Mem
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
               total        used        free      shared  buff/cache   available
Mem:           908Mi       301Mi       382Mi       2.7Mi       334Mi       607Mi
Swap:             0B          0B          0B
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
 PID %CPU %MEM COMMAND
   1006  0.0  0.8 sshd
   1136  0.0  1.2 sshd-session
   1255  0.1  0.8 sshd-session
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
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        6.7G  2.1G  4.6G  31% /
tmpfs            455M     0  455M   0% /dev/shm
tmpfs            182M  892K  181M   1% /run
efivarfs         128K  3.1K  120K   3% /sys/firmware/efi/efivars
none             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs            455M  4.0K  455M   1% /tmp
none             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
/dev/nvme0n1p13  989M   96M  827M  11% /boot
/dev/nvme0n1p15  105M  6.3M   99M   7% /boot/efi
none             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
none             1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyS0.service
none             1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs             91M  8.0K   91M   1% /run/user/1000
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
17M	/var/log
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
Netid       State        Recv-Q       Send-Q                    Local Address:Port               Peer Address:Port
udp         UNCONN       0            0                             127.0.0.1:323                     0.0.0.0:*
udp         UNCONN       0            0                            127.0.0.54:53                      0.0.0.0:*
udp         UNCONN       0            0                         127.0.0.53%lo:53                      0.0.0.0:*
udp         UNCONN       0            0                    172.31.22.115%ens5:68                      0.0.0.0:*
udp         UNCONN       0            0                                 [::1]:323                        [::]:*
tcp         LISTEN       0            4096                      127.0.0.53%lo:53                      0.0.0.0:*
tcp         LISTEN       0            4096                            0.0.0.0:22                      0.0.0.0:*
tcp         LISTEN       0            4096                         127.0.0.54:53                      0.0.0.0:*
tcp         LISTEN       0            4096                               [::]:22                         [::]:*
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
curl: (7) Failed to connect to localhost port 80 after 0 ms: Could not connect to server
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
Jul 31 09:54:17 ip-172-31-22-115 systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Jul 31 09:54:17 ip-172-31-22-115 sshd[1006]: Server listening on 0.0.0.0 port 22.
Jul 31 09:54:17 ip-172-31-22-115 sshd[1006]: Server listening on :: port 22.
Jul 31 09:54:17 ip-172-31-22-115 systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Jul 31 09:54:42 ip-172-31-22-115 sshd-session[1136]: Accepted publickey for ubuntu from 122.161.74.189 port 29786 ssh2: >
Jul 31 09:54:42 ip-172-31-22-115 sshd-session[1136]: pam_unix(sshd:session): session opened for user ubuntu(uid=1000) by>
lines 1-6/6 (END)
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
2026-07-31T09:54:42.933886+00:00 ip-172-31-22-115 systemd[1142]: Queued start job for default target default.target.
2026-07-31T09:54:42.942444+00:00 ip-172-31-22-115 systemd[1142]: Created slice app.slice - User Application Slice.
2026-07-31T09:54:42.942730+00:00 ip-172-31-22-115 systemd[1142]: Started launchpadlib-cache-clean.timer - Clean up old files in the Launchpadlib cache.
2026-07-31T09:54:42.942843+00:00 ip-172-31-22-115 systemd[1142]: Reached target paths.target - Paths.
2026-07-31T09:54:42.942965+00:00 ip-172-31-22-115 systemd[1142]: Reached target timers.target - Timers.
2026-07-31T09:54:42.943064+00:00 ip-172-31-22-115 systemd[1142]: Starting dbus.socket - D-Bus User Message Bus Socket...
2026-07-31T09:54:42.943177+00:00 ip-172-31-22-115 systemd[1142]: Listening on dirmngr.socket - GnuPG network certificate management daemon.
2026-07-31T09:54:42.943302+00:00 ip-172-31-22-115 systemd[1142]: Listening on gpg-agent-browser.socket - GnuPG cryptographic agent and passphrase cache (access for web browsers).
2026-07-31T09:54:42.943412+00:00 ip-172-31-22-115 systemd[1142]: Listening on gpg-agent-extra.socket - GnuPG cryptographic agent and passphrase cache (restricted).
2026-07-31T09:54:42.943994+00:00 ip-172-31-22-115 systemd[1142]: Starting gpg-agent-ssh.socket - GnuPG cryptographic agent (ssh-agent emulation)...
2026-07-31T09:54:42.947874+00:00 ip-172-31-22-115 systemd[1142]: Starting gpg-agent.socket - GnuPG cryptographic agent and passphrase cache...
2026-07-31T09:54:42.948256+00:00 ip-172-31-22-115 systemd[1142]: Listening on keyboxd.socket - GnuPG public key management service.
2026-07-31T09:54:42.948540+00:00 ip-172-31-22-115 systemd[1142]: Listening on pk-debconf-helper.socket - debconf communication socket.
2026-07-31T09:54:42.948800+00:00 ip-172-31-22-115 systemd[1142]: Listening on snapd.session-agent.socket - REST API socket for snapd user session agent.
2026-07-31T09:54:42.952195+00:00 ip-172-31-22-115 systemd[1142]: Starting ssh-agent.socket - OpenSSH Agent socket...
2026-07-31T09:54:42.955762+00:00 ip-172-31-22-115 systemd[1142]: Listening on systemd-ask-password.socket - Query the User Interactively for a Password.
2026-07-31T09:54:42.967913+00:00 ip-172-31-22-115 systemd[1142]: Listening on dbus.socket - D-Bus User Message Bus Socket.
2026-07-31T09:54:42.975873+00:00 ip-172-31-22-115 systemd[1142]: Listening on gpg-agent.socket - GnuPG cryptographic agent and passphrase cache.
2026-07-31T09:54:42.980537+00:00 ip-172-31-22-115 systemd[1142]: Listening on ssh-agent.socket - OpenSSH Agent socket.
2026-07-31T09:54:42.984203+00:00 ip-172-31-22-115 systemd[1142]: Listening on gpg-agent-ssh.socket - GnuPG cryptographic agent (ssh-agent emulation).
2026-07-31T09:54:42.984560+00:00 ip-172-31-22-115 systemd[1142]: Reached target sockets.target - Sockets.
2026-07-31T09:54:42.984780+00:00 ip-172-31-22-115 systemd[1142]: Reached target basic.target - Basic System.
2026-07-31T09:54:42.985010+00:00 ip-172-31-22-115 systemd[1142]: Reached target default.target - Main User Target.
2026-07-31T09:54:42.985230+00:00 ip-172-31-22-115 systemd[1]: Started user@1000.service - User Manager for UID 1000.
2026-07-31T09:54:42.986051+00:00 ip-172-31-22-115 systemd[1142]: Startup finished in 170ms.
2026-07-31T09:54:42.987783+00:00 ip-172-31-22-115 systemd[1]: Started session-1.scope - Session 1 of User ubuntu.
2026-07-31T09:54:43.643092+00:00 ip-172-31-22-115 kernel: kauditd_printk_skb: 1 callbacks suppressed
2026-07-31T09:54:43.643112+00:00 ip-172-31-22-115 kernel: audit: type=1400 audit(1785491683.641:195): apparmor="DENIED" operation="open" class="file" profile="who" name="/usr/share/coreutils/locales/uucore/en-US.ftl" pid=1180 comm="who" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
2026-07-31T09:54:48.106454+00:00 ip-172-31-22-115 systemd[1]: systemd-hostnamed.service: Deactivated successfully.
2026-07-31T09:54:51.152617+00:00 ip-172-31-22-115 systemd[1]: systemd-timedated.service: Deactivated successfully.
2026-07-31T09:59:07.429717+00:00 ip-172-31-22-115 irqbalance[657]: Cannot change IRQ 25 affinity: Permission denied
2026-07-31T09:59:07.429960+00:00 ip-172-31-22-115 irqbalance[657]: IRQ 25 affinity is now unmanaged
2026-07-31T09:59:19.066374+00:00 ip-172-31-22-115 systemd[1]: Starting update-notifier-download.service - Download data for packages that failed at package install time...
2026-07-31T09:59:19.191979+00:00 ip-172-31-22-115 systemd[1]: update-notifier-download.service: Deactivated successfully.
2026-07-31T09:59:19.192316+00:00 ip-172-31-22-115 systemd[1]: Finished update-notifier-download.service - Download data for packages that failed at package install time.
2026-07-31T09:59:21.117233+00:00 ip-172-31-22-115 dbus-daemon[649]: [system] Activating via systemd: service name='org.freedesktop.timedate1' unit='dbus-org.freedesktop.timedate1.service' requested by ':1.11' (uid=0 pid=664 comm="/usr/lib/snapd/snapd" label="unconfined")
2026-07-31T09:59:21.124319+00:00 ip-172-31-22-115 systemd[1]: Starting systemd-timedated.service - Time & Date Service...
2026-07-31T09:59:21.173184+00:00 ip-172-31-22-115 systemd[1]: Started systemd-timedated.service - Time & Date Service.
2026-07-31T09:59:21.173779+00:00 ip-172-31-22-115 dbus-daemon[649]: [system] Successfully activated service 'org.freedesktop.timedate1'
2026-07-31T09:59:51.208136+00:00 ip-172-31-22-115 systemd[1]: systemd-timedated.service: Deactivated successfully.
2026-07-31T10:00:23.533965+00:00 ip-172-31-22-115 systemd[1]: Starting sysstat-collect.service - system activity accounting tool...
2026-07-31T10:00:23.558860+00:00 ip-172-31-22-115 systemd[1]: sysstat-collect.service: Deactivated successfully.
2026-07-31T10:00:23.559187+00:00 ip-172-31-22-115 systemd[1]: Finished sysstat-collect.service - system activity accounting tool.
2026-07-31T10:00:33.530401+00:00 ip-172-31-22-115 systemd[1142]: launchpadlib-cache-clean.service - Clean up old files in the Launchpadlib cache skipped, unmet condition check ConditionPathExists=/home/ubuntu/.launchpadlib/api.launchpad.net/cache
2026-07-31T10:09:19.162695+00:00 ip-172-31-22-115 systemd[1]: Starting systemd-tmpfiles-clean.service - Cleanup of Temporary Directories...
2026-07-31T10:09:19.232014+00:00 ip-172-31-22-115 systemd[1]: systemd-tmpfiles-clean.service: Deactivated successfully.
2026-07-31T10:09:19.232149+00:00 ip-172-31-22-115 systemd[1]: Finished systemd-tmpfiles-clean.service - Cleanup of Temporary Directories.
2026-07-31T10:10:16.338616+00:00 ip-172-31-22-115 systemd[1]: Starting sysstat-collect.service - system activity accounting tool...
2026-07-31T10:10:16.362248+00:00 ip-172-31-22-115 systemd[1]: sysstat-collect.service: Deactivated successfully.
2026-07-31T10:10:16.362599+00:00 ip-172-31-22-115 systemd[1]: Finished sysstat-collect.service - system activity accounting tool.
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
