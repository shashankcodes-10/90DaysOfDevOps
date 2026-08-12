# Day 18 – Shell Scripting: Functions & Intermediate Concepts

## Objective

Learn how to write cleaner and reusable shell scripts using functions, strict mode, local variables, return values, and real-world scripting patterns.

---

# Task 1 – Basic Functions

## Create `functions.sh`

### Script

```bash
#!/bin/bash

greet() {
    local name="$1"
    echo "Hello, $name!"
}

add() {
    local num1="$1"
    local num2="$2"
    echo $((num1 + num2))
}

greet "Shashank"

result=$(add 10 20)
echo "Sum: $result"
```

### Make Executable

```bash
chmod +x functions.sh
```

### Run

```bash
./functions.sh
```

### Output

```text
Hello, Shashank!
Sum: 30
```

### What I Learned

Functions allow commands to be grouped into reusable blocks.

Arguments can be passed to functions and accessed using `$1`, `$2`, etc.

---

# Task 2 – Functions with Return Values

## Create `disk_check.sh`

### Script

```bash
#!/bin/bash

check_disk() {
    echo "Disk Usage:"
    df -h /
}

check_memory() {
    echo "Memory Usage:"
    free -h
}

echo "===== System Resource Check ====="

check_disk

echo

check_memory
```

### Make Executable

```bash
chmod +x disk_check.sh
```

### Run

```bash
./disk_check.sh
```

### Example Output

```text
===== System Resource Check =====

Disk Usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G   8G   12G  40% /

Memory Usage:
              total        used        free
Mem:           3.8Gi       1.2Gi       1.5Gi
Swap:          2.0Gi       0B          2.0Gi
```

### What I Learned

Functions can execute commands and produce output that can be displayed or captured by the main part of a script.

---

# Task 3 – Strict Mode

## Create `strict_demo.sh`

### Script

```bash
#!/bin/bash

set -euo pipefail

echo "Starting strict mode demonstration"

echo "Testing a defined variable:"
NAME="Shashank"
echo "$NAME"

echo "Testing a command:"
mkdir -p /tmp/strict-demo

echo "Script completed successfully"
```

### Make Executable

```bash
chmod +x strict_demo.sh
```

### Run

```bash
./strict_demo.sh
```

### Output

```text
Starting strict mode demonstration
Testing a defined variable:
Shashank
Testing a command:
Script completed successfully
```

---

## Understanding `set -euo pipefail`

### `set -e`

```bash
set -e
```

Causes the script to exit when a command fails, subject to Bash's normal exceptions for commands used in conditional contexts and similar constructs.

Example:

```bash
echo "Before"
false
echo "After"
```

With `set -e`, the script exits after `false`, so `After` is not normally printed.

---

### `set -u`

```bash
set -u
```

Treats an unset variable as an error.

Example:

```bash
set -u

echo "$UNDEFINED_VARIABLE"
```

The script reports an unbound variable and exits.

---

### `set -o pipefail`

```bash
set -o pipefail
```

Makes a pipeline fail if any command in the pipeline fails, rather than only considering the final command's exit status.

Example:

```bash
set -o pipefail

false | true
```

Without `pipefail`, the pipeline can appear successful because `true` succeeds.

With `pipefail`, the pipeline returns a failure status.

---

## Combined Strict Mode

```bash
set -euo pipefail
```

This combines:

```text
-e → Exit when a command fails
-u → Treat unset variables as errors
-o pipefail → Detect failures inside pipelines
```

---

# Task 4 – Local Variables

## Create `local_demo.sh`

### Script

```bash
#!/bin/bash

GLOBAL_VAR="I am global"

show_local() {
    local LOCAL_VAR="I am local"
    echo "Inside function:"
    echo "$LOCAL_VAR"
}

show_regular() {
    REGULAR_VAR="I am a regular variable"
    echo "Inside function:"
    echo "$REGULAR_VAR"
}

show_local

echo "Outside function:"
echo "LOCAL_VAR = ${LOCAL_VAR:-not available}"

show_regular

echo "REGULAR_VAR outside function:"
echo "$REGULAR_VAR"
```

### Make Executable

```bash
chmod +x local_demo.sh
```

### Run

```bash
./local_demo.sh
```

### Example Output

```text
Inside function:
I am local

Outside function:
LOCAL_VAR = not available

Inside function:
I am a regular variable

REGULAR_VAR outside function:
I am a regular variable
```

### What I Learned

A variable declared with:

```bash
local
```

is limited to the function where it is declared.

A regular variable created inside a function can remain available after the function finishes.

Using `local` helps prevent functions from accidentally changing variables outside their intended scope.

---

# Task 5 – System Information Reporter

## Create `system_info.sh`

This script uses functions to display hostname, OS information, uptime, disk usage, memory usage, and CPU-consuming processes.

### Script

```bash
#!/bin/bash

set -euo pipefail

print_header() {
    echo
    echo "========================================"
    echo "$1"
    echo "========================================"
}

hostname_os() {
    print_header "HOSTNAME & OS"

    echo "Hostname: $(hostname)"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "OS: $PRETTY_NAME"
    else
        echo "OS information not available"
    fi
}

show_uptime() {
    print_header "UPTIME"

    uptime
}

disk_usage() {
    print_header "DISK USAGE"

    echo "Top 5 directories by size:"
    du -xhd 1 / 2>/dev/null | sort -hr | head -5
}

memory_usage() {
    print_header "MEMORY USAGE"

    free -h
}

top_cpu_processes() {
    print_header "TOP 5 CPU-CONSUMING PROCESSES"

    ps aux --sort=-%cpu | head -6
}

main() {
    hostname_os
    show_uptime
    disk_usage
    memory_usage
    top_cpu_processes
}

main
```

### Make Executable

```bash
chmod +x system_info.sh
```

### Run

```bash
./system_info.sh
```

### Example Output

```text
========================================
HOSTNAME & OS
========================================
Hostname: devops-server
OS: Ubuntu 24.04 LTS

========================================
UPTIME
========================================
 20:30:10 up 2 days, 4:15, 2 users, load average: 0.20, 0.18, 0.15

========================================
DISK USAGE
========================================
Top 5 directories by size:
8.5G    /
3.2G    /usr
1.8G    /var
1.2G    /home
500M    /opt

========================================
MEMORY USAGE
========================================
              total        used        free
Mem:           3.8Gi       1.2Gi       1.5Gi
Swap:          2.0Gi       0B          2.0Gi

========================================
TOP 5 CPU-CONSUMING PROCESSES
========================================
USER       PID %CPU %MEM COMMAND
root      1234 12.5  2.1 application
ubuntu    2345  8.2  1.5 python
root      3456  5.4  1.2 nginx
```

> The output will vary depending on the system where the script is executed.

---

# Functions Used in `system_info.sh`

| Function              | Purpose                          |
| --------------------- | -------------------------------- |
| `print_header()`      | Prints section headings          |
| `hostname_os()`       | Displays hostname and OS         |
| `show_uptime()`       | Displays system uptime           |
| `disk_usage()`        | Shows largest directories        |
| `memory_usage()`      | Displays memory information      |
| `top_cpu_processes()` | Displays CPU-consuming processes |
| `main()`              | Calls all functions              |

---

# Commands Used

```bash
chmod +x functions.sh
./functions.sh

chmod +x disk_check.sh
./disk_check.sh

chmod +x strict_demo.sh
./strict_demo.sh

chmod +x local_demo.sh
./local_demo.sh

chmod +x system_info.sh
./system_info.sh
```

---

# Scripts Created

```text
functions.sh
disk_check.sh
strict_demo.sh
local_demo.sh
system_info.sh
```

---

# What I Learned

## 1. Functions

Functions allow repeated tasks to be organized into reusable blocks.

```bash
function_name() {
    commands
}
```

They make shell scripts easier to read, maintain, and reuse.

---

## 2. Strict Mode

```bash
set -euo pipefail
```

Strict mode helps make scripts safer by detecting command failures, unset variables, and failures inside pipelines.

---

## 3. Local Variables

Using:

```bash
local VARIABLE="value"
```

keeps a variable limited to the function where it is created.

This helps prevent unintended changes to variables used elsewhere in the script.

---

# Key Takeaway

The scripting structure learned today is:

```text
Shebang
   ↓
Strict Mode
   ↓
Functions
   ↓
Local Variables
   ↓
Commands
   ↓
Main Function
   ↓
Output
```

Functions and strict mode make shell scripts cleaner, safer, and easier to maintain. These patterns are useful when creating real DevOps automation scripts.
