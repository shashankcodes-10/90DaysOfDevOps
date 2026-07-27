# Linux Architecture, Processes & systemd

## 1. Linux Architecture

Linux consists of three main parts:

### Kernel
- Core of the operating system.
- Communicates directly with hardware.
- Manages CPU, memory, devices, files, and processes.
- Provides system calls for applications.

### User Space
- Where user applications run.
- Includes Shell, utilities, browsers, editors, etc.
- Cannot access hardware directly; requests go through the kernel.

### Init / systemd
- First process started by the kernel (PID 1).
- Starts required services during boot.
- Manages background services and system startup.

---

# 2. Process Management

A process is a running instance of a program.

### Process Creation
- A parent process creates a child process.
- Every process has a unique Process ID (PID).
- Processes are scheduled by the kernel.

### Common Process States

| State | Meaning |
|--------|---------|
| Running (R) | Currently using CPU |
| Sleeping (S) | Waiting for an event or input |
| Uninterruptible Sleep (D) | Waiting for I/O operation |
| Stopped (T) | Paused by user or debugger |
| Zombie (Z) | Process finished but parent hasn't collected its status |

---

# 3. What is systemd?

systemd is the default init system in most Linux distributions.

### Responsibilities
- Boots the system
- Starts and stops services
- Restarts failed services
- Handles dependencies
- Manages logs (journalctl)

### Why it matters for DevOps
- Restart crashed applications
- Enable services at boot
- Check service status
- Troubleshoot production servers quickly

---

# 4. Commands I Use Daily

```bash
ps aux              # Show running processes
top                 # Monitor CPU and memory usage
systemctl status nginx   # Check service status
journalctl -u nginx      # View service logs
kill -9 <PID>       # Terminate a process
```

---

# Key Takeaways

- Kernel controls hardware and system resources.
- User Space is where applications run.
- systemd manages services and system startup.
- Every running program is a process with a unique PID.
- Knowing process states and systemd helps in troubleshooting Linux servers.
