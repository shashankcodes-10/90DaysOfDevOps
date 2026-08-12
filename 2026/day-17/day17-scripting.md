# Day 17 – Shell Scripting: Loops, Arguments & Error Handling

## Objective

Level up shell scripting by practicing loops, command-line arguments, package installation, and basic error handling.

---

# Task 1 – For Loop

## 1.1 Create `for_loop.sh`

### Script

```bash
#!/bin/bash

fruits=("Apple" "Banana" "Mango" "Orange" "Grapes")

for fruit in "${fruits[@]}"
do
    echo "$fruit"
done
```

### Make Executable

```bash
chmod +x for_loop.sh
```

### Run

```bash
./for_loop.sh
```

### Output

```text
Apple
Banana
Mango
Orange
Grapes
```

### What I Learned

A `for` loop repeats a set of commands for every item in a list.

---

## 1.2 Create `count.sh`

### Script

```bash
#!/bin/bash

for i in {1..10}
do
    echo "$i"
done
```

### Make Executable

```bash
chmod +x count.sh
```

### Run

```bash
./count.sh
```

### Output

```text
1
2
3
4
5
6
7
8
9
10
```

### What I Learned

A `for` loop can also be used to iterate through a range of numbers.

---

# Task 2 – While Loop

## Create `countdown.sh`

### Script

```bash
#!/bin/bash

read -p "Enter a number: " NUMBER

while [ "$NUMBER" -ge 0 ]
do
    echo "$NUMBER"
    NUMBER=$((NUMBER - 1))
done

echo "Done!"
```

### Make Executable

```bash
chmod +x countdown.sh
```

### Run

```bash
./countdown.sh
```

### Example Output

```text
Enter a number: 5
5
4
3
2
1
0
Done!
```

### What I Learned

A `while` loop continues executing as long as its condition is true.

The value was decreased using:

```bash
NUMBER=$((NUMBER - 1))
```

---

# Task 3 – Command-Line Arguments

## 3.1 Create `greet.sh`

### Script

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./greet.sh <name>"
    exit 1
fi

echo "Hello, $1!"
```

### Make Executable

```bash
chmod +x greet.sh
```

### Run With an Argument

```bash
./greet.sh Shashank
```

### Output

```text
Hello, Shashank!
```

### Run Without an Argument

```bash
./greet.sh
```

### Output

```text
Usage: ./greet.sh <name>
```

### What I Learned

`$1` represents the first command-line argument passed to the script.

---

# 3.2 Create `args_demo.sh`

### Script

```bash
#!/bin/bash

echo "Script name: $0"
echo "Number of arguments: $#"
echo "All arguments: $@"
```

### Make Executable

```bash
chmod +x args_demo.sh
```

### Run

```bash
./args_demo.sh Linux Docker Kubernetes
```

### Output

```text
Script name: ./args_demo.sh
Number of arguments: 3
All arguments: Linux Docker Kubernetes
```

### Important Arguments

| Variable | Meaning |
|----------|---------|
| `$0` | Script name |
| `$1` | First argument |
| `$2` | Second argument |
| `$#` | Number of arguments |
| `$@` | All arguments |

---

# Task 4 – Install Packages via Script

## Create `install_packages.sh`

### Script

```bash
#!/bin/bash

if [[ "$EUID" -ne 0 ]]
then
    echo "Run the script as the root user"
    exit 1
fi

pack=("nginx" "tree" "docker.io" "nmap")

echo "Updating the package repository..."
apt update

for app in "${pack[@]}"
do
    if dpkg -s "$app" &> /dev/null
    then
        echo "$app is already installed"
    else
        echo "$app is not installed, installing it..."

        if apt install -y "$app"
        then
            echo "$app is successfully installed"
        else
            echo "$app installation failed"
        fi
    fi
done
```

### Make Executable

```bash
chmod +x install_packages.sh
```

### Run as Root

```bash
sudo ./install_packages.sh
```

### Example Output

```text
nginx is already installed
curl is already installed
wget is not installed. Installing...
wget installed successfully
```

### What I Learned

The script checks whether it is running as root before attempting to install packages.

It uses `dpkg -s` to check whether a package is already installed.

The `for` loop processes each package in the list.

---

# Task 5 – Error Handling

## Create `safe_script.sh`

### Script

```bash
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test || {
    echo "Failed to enter directory"
    exit 1
}

touch test.txt || {
    echo "Failed to create file"
    exit 1
}

echo "File created successfully"
```

### Make Executable

```bash
chmod +x safe_script.sh
```

### Run

```bash
./safe_script.sh
```

### Example Output

```text
File created successfully
```

If the directory already exists:

```text
mkdir: cannot create directory '/tmp/devops-test': File exists
Directory already exists
File created successfully
```

### What I Learned

`set -e` causes the script to exit when a command fails.

The `||` operator can be used to perform another action when a command fails.

Example:

```bash
mkdir /tmp/devops-test || echo "Directory already exists"
```

---

# Root User Check

The `install_packages.sh` script checks whether it is being run as root.

### Command

```bash
if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi
```

### Test Without sudo

```bash
./install_packages.sh
```

### Expected Output

```text
Run as root
```

### Run Correctly

```bash
sudo ./install_packages.sh
```

---

# Scripts Created

```text
for_loop.sh
count.sh
countdown.sh
greet.sh
args_demo.sh
install_packages.sh
safe_script.sh
```

---

# Commands Used

```bash
chmod +x for_loop.sh
./for_loop.sh

chmod +x count.sh
./count.sh

chmod +x countdown.sh
./countdown.sh

chmod +x greet.sh
./greet.sh Shashank

chmod +x args_demo.sh
./args_demo.sh Linux Docker Kubernetes

chmod +x install_packages.sh
sudo ./install_packages.sh

chmod +x safe_script.sh
./safe_script.sh
```

---

# Key Concepts Learned

## 1. For Loop

A `for` loop is useful when I need to perform the same operation for multiple items.

```bash
for item in list
do
    command
done
```

---

## 2. While Loop

A `while` loop continues running while a condition remains true.

```bash
while [ condition ]
do
    command
done
```

---

## 3. Command-Line Arguments

Shell scripts can receive information directly from the command line.

```bash
$0  # Script name
$1  # First argument
$2  # Second argument
$#  # Number of arguments
$@  # All arguments
```

---

## 4. Error Handling

`set -e` can stop a script when a command fails.

The `||` operator allows an alternative command to run when the previous command fails.

```bash
command || echo "Command failed"
```

---

# What I Learned

1. **Loops** make scripts useful for repeating operations across multiple files, packages, or values.

2. **Command-line arguments** allow scripts to accept dynamic input without requiring interactive prompts.

3. **Error handling** makes scripts safer and more reliable by detecting failures and stopping or taking an alternative action.

---

# Final Takeaway

Today I learned how to move beyond simple shell scripts by adding loops, command-line arguments, package installation, and error handling.

The basic scripting flow I practiced was:

```text
Input / Arguments
       ↓
Variables
       ↓
Loop / Condition
       ↓
Command
       ↓
Error Handling
       ↓
Output
```

These concepts can be combined to automate repetitive Linux and DevOps tasks.
