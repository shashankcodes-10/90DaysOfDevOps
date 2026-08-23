# Shell Scripting Cheat Sheet

> **90 Days of DevOps — Day 21**
>
> Personal quick-reference built from the Shell Scripting topics practiced during Days 16–20.
>
> Use this file for revision and troubleshooting rather than trying to memorize every flag.

---

## Quick Reference

| Topic | Key Syntax | Example |
|---|---|---|
| Shebang | `#!/bin/bash` | `#!/bin/bash` |
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Input | `read` | `read -p "Name: " NAME` |
| Argument | `$1`, `$2` | `./script.sh arg1` |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| For loop | `for i in list; do` | `for i in 1 2 3; do` |
| While loop | `while [ condition ]; do` | `while [ $COUNT -gt 0 ]; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |
| Find | `find path condition` | `find /var/log -name "*.log"` |
| Exit code | `$?` | `echo $?` |
| Strict mode | `set -euo pipefail` | `set -euo pipefail` |
| Trap | `trap 'cleanup' EXIT` | `trap 'rm -f "$TMP"' EXIT` |

---

# 1. Shell Script Basics

## Shebang

The shebang tells the operating system which interpreter should run the script.

```bash
#!/bin/bash
```

Example:

```bash
#!/bin/bash

echo "Hello, DevOps!"
```

---

## Running a Script

Make the script executable:

```bash
chmod +x script.sh
```

Run it:

```bash
./script.sh
```

Or run it directly with Bash:

```bash
bash script.sh
```

---

## Comments

Single-line comment:

```bash
# This is a comment
```

Inline comment:

```bash
echo "Hello"  # Print greeting
```

---

# 2. Variables

Declare a variable without spaces around `=`:

```bash
NAME="Shashank"
ROLE="DevOps Engineer"
```

Use a variable:

```bash
echo "$NAME"
echo "$ROLE"
```

Best practice when expanding variables:

```bash
echo "Hello, $NAME"
```

### Single vs Double Quotes

Double quotes expand variables:

```bash
NAME="Shashank"
echo "Hello $NAME"
```

Output:

```text
Hello Shashank
```

Single quotes treat the variable literally:

```bash
echo 'Hello $NAME'
```

Output:

```text
Hello $NAME
```

---

# 3. Reading User Input

Use `read` to accept input:

```bash
read -p "Enter your name: " NAME
echo "Hello $NAME"
```

Multiple inputs:

```bash
read -p "Name: " NAME
read -p "Favourite tool: " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"
```

---

# 4. Command-Line Arguments

Important Bash special variables:

| Variable | Meaning |
|---|---|
| `$0` | Script name |
| `$1` | First argument |
| `$2` | Second argument |
| `$#` | Number of arguments |
| `$@` | All arguments |
| `$?` | Exit status of previous command |

Example:

```bash
#!/bin/bash

echo "Script: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
echo "All arguments: $@"
```

Run:

```bash
./args_demo.sh Shashank DevOps
```

---

# 5. String Comparisons

Equal:

```bash
if [ "$NAME" = "Shashank" ]; then
    echo "Name matches"
fi
```

Not equal:

```bash
if [ "$NAME" != "Shubham" ]; then
    echo "Names are different"
fi
```

Check empty string:

```bash
if [ -z "$NAME" ]; then
    echo "Name is empty"
fi
```

Check non-empty string:

```bash
if [ -n "$NAME" ]; then
    echo "Name is not empty"
fi
```

---

# 6. Integer Comparisons

| Operator | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-lt` | Less than |
| `-gt` | Greater than |
| `-le` | Less than or equal |
| `-ge` | Greater than or equal |

Example:

```bash
if [ "$NUMBER" -gt 0 ]; then
    echo "Positive"
elif [ "$NUMBER" -lt 0 ]; then
    echo "Negative"
else
    echo "Zero"
fi
```

---

# 7. File Test Operators

| Test | Meaning |
|---|---|
| `-f` | Regular file exists |
| `-d` | Directory exists |
| `-e` | Path exists |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |
| `-s` | File exists and is not empty |

Example:

```bash
if [ -f "notes.txt" ]; then
    echo "File exists"
fi
```

Directory:

```bash
if [ -d "/tmp/devops" ]; then
    echo "Directory exists"
fi
```

Executable:

```bash
if [ -x "script.sh" ]; then
    echo "Script is executable"
fi
```

---

# 8. If / Elif / Else

```bash
if [ condition ]; then
    # commands
elif [ another_condition ]; then
    # commands
else
    # commands
fi
```

Example:

```bash
if [ "$STATUS" = "running" ]; then
    echo "Service is running"
else
    echo "Service is not running"
fi
```

---

# 9. Logical Operators

AND:

```bash
if [ -f "$FILE" ] && [ -r "$FILE" ]; then
    echo "File exists and is readable"
fi
```

OR:

```bash
if [ -f "$FILE" ] || [ -d "$FILE" ]; then
    echo "Path exists"
fi
```

NOT:

```bash
if ! [ -f "$FILE" ]; then
    echo "File does not exist"
fi
```

---

# 10. Case Statement

Useful when handling multiple choices.

```bash
case "$CHOICE" in
    y)
        echo "Yes"
        ;;
    n)
        echo "No"
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
```

---

# 11. For Loops

## List-Based Loop

```bash
for fruit in apple banana mango orange grape; do
    echo "$fruit"
done
```

## Number Loop

```bash
for i in 1 2 3 4 5; do
    echo "$i"
done
```

## C-Style Loop

```bash
for ((i=1; i<=10; i++)); do
    echo "$i"
done
```

---

# 12. While Loop

Runs while a condition is true.

```bash
COUNT=5

while [ "$COUNT" -gt 0 ]; do
    echo "$COUNT"
    COUNT=$((COUNT - 1))
done

echo "Done!"
```

---

# 13. Until Loop

Runs until the condition becomes true.

```bash
COUNT=1

until [ "$COUNT" -gt 5 ]; do
    echo "$COUNT"
    COUNT=$((COUNT + 1))
done
```

---

# 14. Loop Control

Stop a loop:

```bash
for i in 1 2 3 4 5; do
    if [ "$i" -eq 3 ]; then
        break
    fi

    echo "$i"
done
```

Skip the current iteration:

```bash
for i in 1 2 3 4 5; do
    if [ "$i" -eq 3 ]; then
        continue
    fi

    echo "$i"
done
```

---

# 15. Looping Over Files

```bash
for file in *.log; do
    echo "$file"
done
```

Useful for processing multiple log files.

---

# 16. Reading Command Output

```bash
while read -r line; do
    echo "$line"
done < file.txt
```

Example:

```bash
cat file.txt | while read -r line; do
    echo "$line"
done
```

---

# 17. Functions

Define a function:

```bash
greet() {
    echo "Hello, DevOps!"
}
```

Call it:

```bash
greet
```

---

## Function Arguments

```bash
greet() {
    echo "Hello, $1!"
}

greet "Shashank"
```

Multiple arguments:

```bash
add() {
    echo $(( $1 + $2 ))
}

add 10 20
```

---

# 18. Return Values

`return` is normally used for an exit status:

```bash
check_file() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}
```

Check the result:

```bash
check_file "notes.txt"

if [ $? -eq 0 ]; then
    echo "File exists"
fi
```

Use `echo` when a function needs to return actual data:

```bash
get_name() {
    echo "Shashank"
}

NAME=$(get_name)
echo "$NAME"
```

---

# 19. Local Variables

Use `local` inside functions to keep variables scoped to the function.

```bash
demo() {
    local MESSAGE="Hello"
    echo "$MESSAGE"
}

demo
```

---

# 20. Text Processing – `grep`

Search for a pattern:

```bash
grep "ERROR" app.log
```

Case-insensitive:

```bash
grep -i "error" app.log
```

Recursive:

```bash
grep -r "ERROR" /var/log
```

Count matches:

```bash
grep -c "ERROR" app.log
```

Show line numbers:

```bash
grep -n "ERROR" app.log
```

Invert match:

```bash
grep -v "INFO" app.log
```

Extended regular expressions:

```bash
grep -E "ERROR|Failed" app.log
```

---

# 21. `awk`

Print first column:

```bash
awk '{print $1}' file.txt
```

Print multiple columns:

```bash
awk '{print $1, $3}' file.txt
```

Use a field separator:

```bash
awk -F: '{print $1}' /etc/passwd
```

Pattern matching:

```bash
awk '/ERROR/ {print}' app.log
```

`BEGIN` and `END`:

```bash
awk 'BEGIN {print "Start"} {print $1} END {print "Done"}' file.txt
```

---

# 22. `sed`

Replace text:

```bash
sed 's/old/new/g' file.txt
```

Delete a line:

```bash
sed '5d' file.txt
```

Delete lines matching a pattern:

```bash
sed '/ERROR/d' file.txt
```

In-place replacement:

```bash
sed -i 's/foo/bar/g' config.txt
```

> On macOS, `sed -i` has different syntax. A common form is:
>
> ```bash
> sed -i '' 's/foo/bar/g' config.txt
> ```

---

# 23. `cut`

Extract a column using a delimiter:

```bash
cut -d: -f1 /etc/passwd
```

Extract characters:

```bash
cut -c1-10 file.txt
```

---

# 24. `sort`

Alphabetical sorting:

```bash
sort file.txt
```

Numeric sorting:

```bash
sort -n numbers.txt
```

Reverse sorting:

```bash
sort -r file.txt
```

Unique sorting:

```bash
sort -u file.txt
```

---

# 25. `uniq`

Remove consecutive duplicate lines:

```bash
uniq file.txt
```

Count duplicates:

```bash
uniq -c file.txt
```

Common pattern:

```bash
sort file.txt | uniq -c
```

---

# 26. `tr`

Translate characters:

```bash
echo "hello" | tr 'a-z' 'A-Z'
```

Delete characters:

```bash
echo "hello123" | tr -d '0-9'
```

---

# 27. `wc`

Count lines:

```bash
wc -l file.txt
```

Count words:

```bash
wc -w file.txt
```

Count characters:

```bash
wc -c file.txt
```

---

# 28. `head` and `tail`

First 5 lines:

```bash
head -n 5 file.txt
```

Last 5 lines:

```bash
tail -n 5 file.txt
```

Follow a log in real time:

```bash
tail -f app.log
```

Follow and show the last 50 lines:

```bash
tail -n 50 -f app.log
```

---

# 29. `find`

Find `.log` files:

```bash
find /var/log -name "*.log"
```

Find files older than 7 days:

```bash
find /var/log -name "*.log" -mtime +7
```

Find and delete old files:

```bash
find /tmp -type f -mtime +7 -delete
```

Find directories:

```bash
find . -type d -name "logs"
```

Find and execute a command:

```bash
find . -name "*.log" -exec gzip {} \;
```

---

# 30. Useful One-Liners

## Find Large Files

```bash
du -sh * | sort -h | tail -5
```

Shows the largest entries after sorting by size.

---

## Count Errors in a Log

```bash
grep -ci "error" app.log
```

Counts error lines without caring about case.

---

## Follow Logs and Show Errors

```bash
tail -f app.log | grep --line-buffered -i "error"
```

Useful for real-time troubleshooting.

---

## Find and Compress Old Logs

```bash
find /var/log -name "*.log" -mtime +7 -exec gzip {} \;
```

Compresses `.log` files older than 7 days.

---

## Replace Text Across Files

```bash
sed -i 's/old/new/g' *.conf
```

On macOS:

```bash
sed -i '' 's/old/new/g' *.conf
```

---

## Count Lines in All Log Files

```bash
wc -l *.log
```

---

## Find Top Error Messages

```bash
grep "ERROR" app.log | sort | uniq -c | sort -rn | head -5
```

Useful for quickly identifying repeated errors.

---

## Check Whether a File Exists

```bash
[ -f "app.log" ] && echo "Exists" || echo "Missing"
```

---

## Check Command Success

```bash
command

if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Failed"
fi
```

A shorter pattern:

```bash
command && echo "Success" || echo "Failed"
```

---

# 31. Exit Codes

Successful command:

```bash
exit 0
```

Failure:

```bash
exit 1
```

Check the previous command's exit status:

```bash
echo $?
```

Common idea:

```text
0     = success
non-0 = failure
```

---

# 32. Error Handling

## `set -e`

Exit the script when a command fails.

```bash
#!/bin/bash

set -e

mkdir /tmp/devops-test
cd /tmp/devops-test
```

---

## `set -u`

Treat unset variables as errors.

```bash
#!/bin/bash

set -u

echo "$UNDEFINED_VARIABLE"
```

---

## `set -o pipefail`

Makes a pipeline fail if an earlier command fails.

```bash
set -o pipefail
```

---

## Strict Mode

A common safer scripting pattern:

```bash
#!/bin/bash

set -euo pipefail
```

Meaning:

```text
-e  exit when a command fails
-u  error on unset variables
-o pipefail  catch failures inside pipelines
```

---

# 33. Debugging with `set -x`

Shows commands as Bash executes them.

```bash
#!/bin/bash

set -x

echo "Starting script"
mkdir /tmp/devops-test
echo "Finished"
```

Disable it:

```bash
set +x
```

---

# 34. Trap

`trap` lets a script run cleanup code when it exits.

```bash
cleanup() {
    echo "Cleaning up..."
}

trap 'cleanup' EXIT
```

Temporary-file example:

```bash
TMP="/tmp/devops-temp"

touch "$TMP"

cleanup() {
    rm -f "$TMP"
}

trap 'cleanup' EXIT
```

---

# 35. Practical Script Template

A useful starting point for DevOps scripts:

```bash
#!/bin/bash

set -euo pipefail

usage() {
    echo "Usage: $0 <argument>"
    exit 1
}

cleanup() {
    echo "Cleaning up..."
}

trap 'cleanup' EXIT

if [ $# -lt 1 ]; then
    usage
fi

INPUT="$1"

echo "Processing: $INPUT"
```

---

# 36. Log Analyzer Pattern

The Day 20 project combined several commands:

```bash
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)
```

Critical events:

```bash
grep -n "CRITICAL" "$LOG_FILE"
```

Top error messages:

```bash
grep "ERROR" "$LOG_FILE" |
    awk '{$1=$2=$3=""; print}' |
    sort |
    uniq -c |
    sort -rn |
    head -5
```

This is a good example of combining small Linux tools into a useful automation pipeline.

---

# 37. Backup Pattern

Create a timestamp:

```bash
DATE=$(date +%Y-%m-%d)
```

Create a compressed archive:

```bash
tar -czf "backup-${DATE}.tar.gz" /source/directory
```

Check that it exists:

```bash
if [ -f "backup-${DATE}.tar.gz" ]; then
    echo "Backup created successfully"
fi
```

---

# 38. Cron Patterns

View scheduled jobs:

```bash
crontab -l
```

Edit cron jobs:

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

Every 5 minutes:

```cron
*/5 * * * * /path/to/health_check.sh
```

Every day at 2 AM:

```cron
0 2 * * * /path/to/log_rotate.sh
```

Every Sunday at 3 AM:

```cron
0 3 * * 0 /path/to/backup.sh
```

---

# 39. Script Debugging Checklist

When a script fails:

```bash
bash -n script.sh
```

Checks syntax without executing the script.

Run with tracing:

```bash
bash -x script.sh
```

Check permissions:

```bash
ls -l script.sh
```

Make executable:

```bash
chmod +x script.sh
```

Run:

```bash
./script.sh
```

Check the previous command's status:

```bash
echo $?
```

---

# 40. Practical DevOps Workflow

When writing a Bash automation script:

```text
1. Define the input
       ↓
2. Validate input
       ↓
3. Check prerequisites
       ↓
4. Perform the operation
       ↓
5. Check exit status
       ↓
6. Handle errors
       ↓
7. Log useful information
       ↓
8. Clean up temporary files
       ↓
9. Exit with the correct status
```

---

# 41. Flags I Should Actually Remember

I do **not** need to memorize every flag of every Linux command.

Focus on the flags I repeatedly use during troubleshooting.

### `grep`

```bash
-i   # case-insensitive
-r   # recursive
-c   # count
-n   # line numbers
-v   # invert match
-E   # extended patterns
```

### `head` / `tail`

```bash
-n 50    # number of lines
-f       # follow output
```

### `sort`

```bash
-n   # numeric
-r   # reverse
-u   # unique
```

### `find`

```bash
-name
-type
-mtime
-exec
-delete
```

### Important principle

> **Don't memorize every flag. Understand the command, know the common flags, and use `man <command>` or `<command> --help` when you need a flag you don't remember.**

Examples:

```bash
man grep
grep --help

man find
find --help
```

---

# 42. My Most Important Commands for DevOps

If I had to quickly pick commands during an incident:

```bash
ps aux
top
df -h
du -sh *
free -h
ls -l
find
grep
awk
sed
tail -f
curl
ping
ss
dig
systemctl status <service>
journalctl -u <service>
```

For shell scripting specifically:

```bash
echo
read
if
case
for
while
function
grep
awk
sed
find
sort
uniq
cut
wc
head
tail
set -euo pipefail
$?
$1
$@
$#
```

---

# 43. Final Takeaways

### 1. Shell scripting is about combining simple commands

Commands such as:

```bash
grep
awk
sed
sort
uniq
find
```

become powerful when combined with pipes and scripts.

### 2. Write scripts for repeatable work

If I perform the same troubleshooting or maintenance task repeatedly, it is a good candidate for automation.

### 3. Error handling matters

Production scripts should validate inputs, check failures, use meaningful exit codes, and clean up after themselves.

---

# Day 21 Checklist

- [x] Shebang
- [x] Variables
- [x] User input
- [x] Command-line arguments
- [x] Conditions
- [x] Loops
- [x] Functions
- [x] `grep`
- [x] `awk`
- [x] `sed`
- [x] `cut`
- [x] `sort`
- [x] `uniq`
- [x] `tr`
- [x] `wc`
- [x] `head`
- [x] `tail`
- [x] `find`
- [x] Exit codes
- [x] `set -e`
- [x] `set -u`
- [x] `pipefail`
- [x] `set -x`
- [x] `trap`
- [x] Cron basics
- [x] Log analysis patterns
- [x] Backup patterns

---

# Learn in Public

I consolidated my Shell Scripting learning from Days 16–20 into a practical cheat sheet covering Bash fundamentals, loops, functions, text processing, error handling, log analysis, and automation.

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
