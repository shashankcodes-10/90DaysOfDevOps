# Day 16 – Shell Scripting Basics

## Objective

Learn the fundamentals of Bash shell scripting, including the shebang, variables, user input, and basic `if-else` conditions.

---

# Task 1 – My First Shell Script

## Create `hello.sh`

### Script

```bash
#!/bin/bash

echo "Hello, DevOps!"
```

### Make the Script Executable

```bash
chmod +x hello.sh
```

### Run the Script

```bash
./hello.sh
```

### Output

```text
Hello, DevOps!
```

### What I Learned

The first line:

```bash
#!/bin/bash
```

is called the **shebang**.

It tells the system to use Bash to interpret the script.

### What happens if the shebang is removed?

Without the shebang, running the script directly with:

```bash
./hello.sh
```

may fail or be interpreted using the user's default shell, depending on the system and script contents.

The shebang makes the intended interpreter explicit.

---

# Task 2 – Variables

## Create `variables.sh`

### Script

```bash
#!/bin/bash

NAME="Shashank"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
```

### Make Executable

```bash
chmod +x variables.sh
```

### Run

```bash
./variables.sh
```

### Output

```text
Hello, I am Shashank and I am a DevOps Engineer
```

### What I Learned

Variables store values that can be reused in a script.

The variable is assigned without spaces around `=`:

```bash
NAME="Shashank"
```

The variable value is accessed using `$`:

```bash
$NAME
```

---

## Single Quotes vs Double Quotes

### Double Quotes

```bash
NAME="Shashank"

echo "Hello $NAME"
```

Output:

```text
Hello Shashank
```

Double quotes allow variables to be expanded.

---

### Single Quotes

```bash
echo 'Hello $NAME'
```

Output:

```text
Hello $NAME
```

Single quotes treat the contents literally, so `$NAME` is not expanded.

---

# Task 3 – User Input with `read`

## Create `greet.sh`

### Script

```bash
#!/bin/bash

read -p "Enter your name: " NAME
read -p "Enter your favourite tool: " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"
```

### Make Executable

```bash
chmod +x greet.sh
```

### Run

```bash
./greet.sh
```

### Example Output

```text
Enter your name: Shashank
Enter your favourite tool: Docker

Hello Shashank, your favourite tool is Docker
```

### What I Learned

The `read` command accepts input from the user and stores it in a variable.

Example:

```bash
read -p "Enter name: " NAME
```

---

# Task 4 – If-Else Conditions

## 4.1 Check Number

Create:

```text
check_number.sh
```

### Script

```bash
#!/bin/bash

read -p "Enter a number: " NUMBER

if [ "$NUMBER" -gt 0 ]; then
    echo "The number is positive"
elif [ "$NUMBER" -lt 0 ]; then
    echo "The number is negative"
else
    echo "The number is zero"
fi
```

### Make Executable

```bash
chmod +x check_number.sh
```

### Run

```bash
./check_number.sh
```

### Example

```text
Enter a number: 10
The number is positive
```

Another example:

```text
Enter a number: -5
The number is negative
```

Another example:

```text
Enter a number: 0
The number is zero
```

### What I Learned

`if`, `elif`, and `else` allow a script to make decisions based on conditions.

The basic structure is:

```bash
if [ condition ]; then
    command
elif [ condition ]; then
    command
else
    command
fi
```

---

# 4.2 File Check

Create:

```text
file_check.sh
```

### Script

```bash
#!/bin/bash

read -p "Enter a filename: " FILE

if [ -f "$FILE" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
```

### Make Executable

```bash
chmod +x file_check.sh
```

### Run

```bash
./file_check.sh
```

### Example

```text
Enter a filename: notes.txt
File exists
```

If the file does not exist:

```text
Enter a filename: test.txt
File does not exist
```

### What I Learned

The `-f` condition checks whether a path exists and is a regular file.

---

# Task 5 – Combine It All

## Create `server_check.sh`

### Script

```bash
#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status? (y/n): " CHOICE

if [ "$CHOICE" = "y" ]; then

    if systemctl is-active --quiet "$SERVICE"; then
        echo "$SERVICE is active"
    else
        echo "$SERVICE is not active"
    fi

elif [ "$CHOICE" = "n" ]; then
    echo "Skipped."

else
    echo "Invalid choice."
fi
```

### Make Executable

```bash
chmod +x server_check.sh
```

### Run

```bash
./server_check.sh
```

### Example – Service Active

```text
Do you want to check the status? (y/n): y
nginx is active
```

### Example – Skip

```text
Do you want to check the status? (y/n): n
Skipped.
```

### What I Learned

This script combines:

- Variables
- User input
- `if-else`
- `systemctl`
- Service status checking

Instead of manually checking a service every time, the script can perform the check automatically.

---

# Scripts Created

```text
hello.sh
variables.sh
greet.sh
check_number.sh
file_check.sh
server_check.sh
```

---

# Commands Used

```bash
chmod +x hello.sh
./hello.sh

chmod +x variables.sh
./variables.sh

chmod +x greet.sh
./greet.sh

chmod +x check_number.sh
./check_number.sh

chmod +x file_check.sh
./file_check.sh

chmod +x server_check.sh
./server_check.sh
```

---

# What I Learned

### 1. Shebang

```bash
#!/bin/bash
```

Specifies Bash as the interpreter for the script.

### 2. Variables and User Input

Variables store values, while `read` allows the script to accept input from the user.

```bash
NAME="Shashank"

read -p "Enter name: " NAME
```

### 3. Conditional Logic

`if`, `elif`, and `else` allow shell scripts to make decisions based on conditions.

```bash
if [ condition ]; then
    ...
else
    ...
fi
```

---

# Key Takeaway

Shell scripting allows repetitive Linux tasks to be converted into reusable scripts.

The basic flow learned today is:

```text
Input
  ↓
Variables
  ↓
Condition
  ↓
Action
  ↓
Output
```

These fundamentals will be useful for automating Linux administration and DevOps tasks.
