# Linux Commands Cheat Sheet

## Process Management

| Command | Description |
|---------|-------------|
| `ps` | Show processes running in the current terminal. |
| `ps aux` | Display all running processes with CPU and memory usage. |
| `ps -ef` | List all running processes in full format. |
| `ps -ef --forest` | Display processes in a parent-child hierarchy. |
| `top` | Monitor system processes and resource usage in real time. |
| `htop` | Interactive process viewer (if installed). |
| `pgrep <process>` | Find the PID of a process by name. |
| `pidof <process>` | Show the PID of a running process. |
| `kill <PID>` | Gracefully terminate a process. |
| `kill -9 <PID>` | Forcefully terminate a process. |
| `killall <process>` | Kill all processes with the specified name. |
| `jobs` | List background jobs in the current shell. |
| `bg` | Resume a stopped job in the background. |
| `fg` | Bring a background job to the foreground. |
| `pstree -p` | Display processes in a tree with PIDs. |

---

## File System

| Command | Description |
|---------|-------------|
| `pwd` | Display the current working directory. |
| `ls -l` | List files and directories with details. |
| `ls -la` | List all files, including hidden files. |
| `cd <directory>` | Change the current directory. |
| `mkdir <directory>` | Create a new directory. |
| `rmdir <directory>` | Remove an empty directory. |
| `touch <file>` | Create an empty file. |
| `cp <source> <destination>` | Copy files or directories. |
| `mv <source> <destination>` | Move or rename files/directories. |
| `rm <file>` | Delete a file. |
| `rm -r <directory>` | Remove a directory recursively. |
| `cat <file>` | Display the contents of a file. |
| `less <file>` | View a file one page at a time. |
| `head <file>` | Display the first 10 lines of a file. |
| `tail <file>` | Display the last 10 lines of a file. |
| `tail -f <file>` | Follow a file (commonly used for logs). |
| `grep "<text>" <file>` | Search for text inside a file. |
| `find <path> -name "<file>"` | Search for files by name. |
| `du -sh <directory>` | Display the size of a directory. |
| `df -h` | Display disk usage in a human-readable format. |

---

## Networking

| Command | Description |
|---------|-------------|
| `ping <host>` | Check network connectivity to a host. |
| `ip addr` | Display IP addresses of network interfaces. |
| `ip route` | Display the routing table. |
| `ss -tuln` | Show listening TCP and UDP ports. |
| `curl <URL>` | Send an HTTP request to a URL. |
| `wget <URL>` | Download files from the internet. |
| `dig <domain>` | Perform a DNS lookup. |
| `nslookup <domain>` | Query DNS records for a domain. |
| `traceroute <host>` | Display the path packets take to a host. |
| `hostname -I` | Show the system's IP address. |

---

## Logs & Services

| Command | Description |
|---------|-------------|
| `systemctl status <service>` | Check the status of a service. |
| `systemctl start <service>` | Start a service. |
| `systemctl stop <service>` | Stop a service. |
| `systemctl restart <service>` | Restart a service. |
| `systemctl enable <service>` | Enable a service to start on boot. |
| `systemctl disable <service>` | Disable automatic startup of a service. |
| `systemctl is-active <service>` | Check if a service is currently running. |
| `journalctl` | Display system logs. |
| `journalctl -u <service>` | View logs for a specific service. |
| `journalctl -f` | Follow logs in real time. |

---

# Most Used DevOps Commands

- `ps aux` – View running processes.
- `top` – Monitor CPU and memory usage.
- `systemctl status` – Check service status.
- `journalctl -u` – View service logs.
- `tail -f` – Monitor log files in real time.
- `grep` – Search text inside files.
- `find` – Locate files.
- `curl` – Test APIs and web services.
- `ip addr` – Check network interfaces.
- `ping` – Verify network connectivity.

---

# Key Takeaways

- Process commands help monitor and manage running applications.
- File system commands simplify navigation and file management.
- Networking commands are essential for troubleshooting connectivity issues.
- Log and service commands are critical for debugging production systems.
- These commands form the foundation of daily Linux and DevOps operations.
