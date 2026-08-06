# Day 10 – File Permissions & File Operations Challenge

## Objective

Learn how to create, read, and manage files in Linux while understanding file permissions using `chmod`.

---

# Task 1 – Create Files

## Create an Empty File

```bash
touch devops.txt
```

### Observation

Created an empty file named `devops.txt`.

---

## Create a File with Content

```bash
echo "Linux file permissions are important." > notes.txt
echo "DevOps engineers work with configuration files." >> notes.txt
echo "Practice Linux commands every day." >> notes.txt
```

### Observation

Created `notes.txt` and added three lines of content.

---

## Create a Shell Script

```bash
vim script.sh
```

### Add the Following Content

```bash
#!/bin/bash
echo "Hello DevOps"
```

Save and exit.

### Verify

```bash
ls -l
```

### Observation

Verified that all files were created successfully.

---

# Task 2 – Read Files

## Read notes.txt

```bash
cat notes.txt
```

### Observation
```
Linux file permissions are important.
DevOps engineers work with configuration files.
Practice Linux commands every day.
```
---

## Open script.sh in Read-Only Mode

```bash
vim -R script.sh
```

### Observation

Viewed the script without modifying it.

---

## Display First 5 Lines of /etc/passwd

```bash
head -n 5 /etc/passwd
```

### Observation
```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
```
---

## Display Last 5 Lines of /etc/passwd

```bash
tail -n 5 /etc/passwd
```

### Observation

```
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,ubuntu
```

---

# Task 3 – Understand Permissions

## Check Current Permissions

```bash
ls -l devops.txt notes.txt script.sh
```

### Example Output

```text
-rw-r--r-- devops.txt
-rw-r--r-- notes.txt
-rw-r--r-- script.sh
```

### Understanding Permissions

```
-rwxrwxrwx

Owner  Group  Others
```

| Permission | Value |
|------------|------:|
| Read (r) | 4 |
| Write (w) | 2 |
| Execute (x) | 1 |

### Observation

- Owner has read and write permission.
- Group has read permission.
- Others have read permission.
- `script.sh` is **not executable** yet.

---

# Task 4 – Modify Permissions

## Make script.sh Executable

```bash
chmod +x script.sh
```

### Verify

```bash
ls -l script.sh
```

### Execute

```bash
./script.sh
```

### Output

```text
Hello DevOps
```

---

## Make devops.txt Read-Only

```bash
chmod a-w devops.txt
```

### Verify

```bash
ls -l devops.txt
```

---

## Set notes.txt Permissions to 640

```bash
chmod 640 notes.txt
```

### Verify

```bash
ls -l notes.txt
```

---

## Create Project Directory

```bash
mkdir project
```

### Set Permission

```bash
chmod 755 project
```

### Verify

```bash
ls -ld project
```

---

# Task 5 – Test Permissions

## Try Writing to Read-Only File

```bash
echo "Testing" >> devops.txt
```

### Expected Result

```text
Permission denied
```

---

## Remove Execute Permission

```bash
chmod -x script.sh
```

### Try Running the Script

```bash
./script.sh
```

### Expected Result

```text
Permission denied
```

### Observation

A file without execute permission cannot be executed.

---

# Commands Used

```bash
touch devops.txt

echo "Linux file permissions are important." > notes.txt
echo "DevOps engineers work with configuration files." >> notes.txt
echo "Practice Linux commands every day." >> notes.txt

vim script.sh

ls -l

cat notes.txt

vim -R script.sh

head -n 5 /etc/passwd

tail -n 5 /etc/passwd

chmod +x script.sh

./script.sh

chmod a-w devops.txt

chmod 640 notes.txt

mkdir project

chmod 755 project

echo "Testing" >> devops.txt

chmod -x script.sh

./script.sh
```

---

# Files Created

```
devops.txt
notes.txt
script.sh
project/
```

---

# Verification Checklist

- ✅ Created all required files
- ✅ Read files using `cat`, `head`, `tail`, and `vim`
- ✅ Understood Linux permission format (`rwxrwxrwx`)
- ✅ Made a script executable
- ✅ Changed file permissions using symbolic and numeric methods
- ✅ Created a directory with `755` permissions
- ✅ Tested permission-related errors

---

# Key Learnings

- `touch` creates an empty file.
- `cat`, `head`, and `tail` are useful for reading files.
- `vim -R` opens a file in read-only mode.
- `chmod +x` adds execute permission.
- `chmod a-w` removes write permission from all users.
- `chmod 640` gives read/write to the owner, read to the group, and no access to others.
- `chmod 755` is commonly used for directories.
- Linux permissions determine who can read, write, and execute files.
