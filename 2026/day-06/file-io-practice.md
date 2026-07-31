# File I/O Practice

## Objective

Practice basic Linux file input/output operations using fundamental commands.

---

## 1. Create a File

### Command

```bash
touch notes.txt
```

### What it does

Creates an empty file named `notes.txt`.

---

## 2. Write the First Line

### Command

```bash
echo "Linux File I/O Practice" > notes.txt
```

### What it does

Writes the first line to the file. If the file already contains data, it is overwritten.

---

## 3. Append the Second Line

### Command

```bash
echo "Learning output redirection using >>." >> notes.txt
```

### What it does

Appends a new line to the end of the file without removing existing content.

---

## 4. Append the Third Line Using tee

### Command

```bash
echo "Using tee command to write and display." | tee -a notes.txt
```

### Output

```text
Using tee command to write and display.
```

### What it does

Displays the text on the terminal and appends it to the file.

---

## 5. Add More Content

### Commands

```bash
echo "Linux is the foundation of DevOps." >> notes.txt
echo "Practice commands every day." >> notes.txt
echo "Configuration files are usually text files." >> notes.txt
echo "Logs help during troubleshooting." >> notes.txt
echo "This is the last line." >> notes.txt
```

---

## 6. Read the Entire File

### Command

```bash
cat notes.txt
```

### Output

```text
Linux File I/O Practice
Learning output redirection using >>.
Using tee command to write and display.
Linux is the foundation of DevOps.
Practice commands every day.
Configuration files are usually text files.
Logs help during troubleshooting.
This is the last line.
```

### What it does

Displays the complete contents of the file.

---

## 7. Read the First Two Lines

### Command

```bash
head -n 2 notes.txt
```

### Output

```text
Linux File I/O Practice
Learning output redirection using >>.
```

### What it does

Displays only the first two lines of the file.

---

## 8. Read the Last Two Lines

### Command

```bash
tail -n 2 notes.txt
```

### Output

```text
Logs help during troubleshooting.
This is the last line.
```

### What it does

Displays only the last two lines of the file.

---

# Commands Used

```bash
touch notes.txt

echo "Linux File I/O Practice" > notes.txt

echo "Learning output redirection using >>." >> notes.txt

echo "Using tee command to write and display." | tee -a notes.txt

echo "Linux is the foundation of DevOps." >> notes.txt

echo "Practice commands every day." >> notes.txt

echo "Configuration files are usually text files." >> notes.txt

echo "Logs help during troubleshooting." >> notes.txt

echo "This is the last line." >> notes.txt

cat notes.txt

head -n 2 notes.txt

tail -n 2 notes.txt
```

---

# Key Learnings

- `touch` creates a new empty file.
- `>` writes data and overwrites existing content.
- `>>` appends data without deleting existing content.
- `tee -a` writes to a file and displays the output simultaneously.
- `cat` reads the entire file.
- `head` displays the beginning of a file.
- `tail` displays the end of a file.
