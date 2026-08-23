# Day 20 – Bash Scripting Challenge: Log Analyzer and Report Generator

## Objective

Today I built a Bash log analyzer that automatically inspects a log file, identifies errors and critical events, finds the most common error messages, and generates a daily summary report.

The main concepts practiced were:

- Bash command-line arguments
- Input validation
- `grep`
- `awk`
- `sort`
- `uniq`
- `head`
- Line-number searching
- Report generation
- File handling

---

# Task 1 – Input and Validation

The script accepts the log file path as a command-line argument.

```bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log-file>"
    exit 1
fi
```

Check whether the log file exists:

```bash
if [ ! -f "$1" ]; then
    echo "Error: Log file does not exist"
    exit 1
fi
```

Example:

```bash
./log_analyzer.sh sample_log.log
```

---

# Task 2 – Error Count

The script counts lines containing either `ERROR` or `Failed`.

```bash
error_count=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)
```

Display the result:

```bash
echo "Total errors: $error_count"
```

`grep` searches the log file for specific patterns.

- `-E` allows multiple patterns.
- `-i` makes the search case-insensitive.

---

# Task 3 – Critical Events

Find critical events along with their line numbers:

```bash
grep -n "CRITICAL" "$LOG_FILE"
```

Example:

```text
--- Critical Events ---
84:2025-07-29 10:15:23 CRITICAL Disk space below threshold
217:2025-07-29 14:32:01 CRITICAL Database connection lost
```

The `-n` option displays the line number where the match was found.

---

# Task 4 – Top 5 Error Messages

The script extracts lines containing `ERROR` and processes them using `awk`, `sort`, `uniq`, and `head`.

```bash
grep "ERROR" "$LOG_FILE" |
awk '{$1=$2=$3=""; print}' |
sort |
uniq -c |
sort -rn |
head -5
```

### What each command does

```bash
grep "ERROR" "$LOG_FILE"
```

Finds lines containing `ERROR`.

```bash
awk '{$1=$2=$3=""; print}'
```

Removes the first three fields so the remaining text represents the error message.

```bash
sort
```

Sorts identical messages together.

```bash
uniq -c
```

Counts repeated messages.

```bash
sort -rn
```

Sorts the results numerically in descending order.

```bash
head -5
```

Displays the top five results.

Example:

```text
--- Top 5 Error Messages ---
45 Connection timed out
32 File not found
28 Permission denied
15 Disk I/O error
9 Out of memory
```

---

# Task 5 – Summary Report

Generate the report filename using the current date:

```bash
DATE=$(date +%Y-%m-%d)
REPORT="log_report_${DATE}.txt"
```

The report contains:

- Date of analysis
- Log file name
- Total lines processed
- Total error count
- Top 5 error messages
- Critical events

---

# `log_analyzer.sh`

```bash
#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log-file>"
    exit 1
fi

LOG_FILE="$1"

# Check file
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file does not exist"
    exit 1
fi

DATE=$(date +%Y-%m-%d)
REPORT="log_report_${DATE}.txt"

# Count total lines
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# Count ERROR or Failed lines
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

# Critical events
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE")

# Top 5 error messages
TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" |
    awk '{$1=$2=$3=""; print}' |
    sort |
    uniq -c |
    sort -rn |
    head -5)

# Display results
echo "Log Analysis Report"
echo "==================="
echo "Log file: $LOG_FILE"
echo "Total lines: $TOTAL_LINES"
echo "Total errors: $ERROR_COUNT"

echo
echo "--- Critical Events ---"
echo "$CRITICAL_EVENTS"

echo
echo "--- Top 5 Error Messages ---"
echo "$TOP_ERRORS"

# Generate report
cat > "$REPORT" << EOF
Log Analysis Report
===================

Date of Analysis: $DATE
Log File: $LOG_FILE
Total Lines Processed: $TOTAL_LINES
Total Error Count: $ERROR_COUNT

--- Top 5 Error Messages ---

$TOP_ERRORS

--- Critical Events ---

$CRITICAL_EVENTS
EOF

echo
echo "Report generated: $REPORT"
```

---

# Running the Script

Make the script executable:

```bash
chmod +x log_analyzer.sh
```

Run it against the sample log:

```bash
./log_analyzer.sh sample_log.log
```

The script generates a report similar to:

```text
log_report_2026-08-23.txt
```

---

# Sample Report Structure

```text
Log Analysis Report
===================

Date of Analysis: 2026-08-23
Log File: sample_log.log
Total Lines Processed: 250
Total Error Count: 97

--- Top 5 Error Messages ---

45 Connection timed out
32 File not found
28 Permission denied
15 Disk I/O error
9 Out of memory

--- Critical Events ---

84:2025-07-29 10:15:23 CRITICAL Disk space below threshold
217:2025-07-29 14:32:01 CRITICAL Database connection lost
```

---

# Task 6 – Optional Archive Processed Logs

Create the archive directory:

```bash
mkdir -p archive
```

Move the processed log:

```bash
mv "$LOG_FILE" archive/
```

Print confirmation:

```bash
echo "Log file moved to archive/"
```

I would only enable this after verifying that the analysis and report generation work correctly because moving the original log changes its location.

---

# Commands and Tools Practiced

## `grep`

Searches for patterns inside files.

```bash
grep "ERROR" sample_log.log
```

## `grep -n`

Searches for a pattern and displays line numbers.

```bash
grep -n "CRITICAL" sample_log.log
```

## `grep -E`

Allows multiple search patterns.

```bash
grep -E "ERROR|Failed" sample_log.log
```

## `grep -i`

Makes the search case-insensitive.

```bash
grep -i "error" sample_log.log
```

## `wc -l`

Counts the number of lines.

```bash
wc -l sample_log.log
```

## `awk`

Processes and extracts text fields.

```bash
awk '{$1=$2=$3=""; print}' file
```

## `sort`

Sorts text.

```bash
sort file
```

## `uniq -c`

Counts repeated lines.

```bash
uniq -c
```

## `sort -rn`

Sorts numbers in reverse order.

```bash
sort -rn
```

## `head`

Displays the first lines of output.

```bash
head -5
```

## `date`

Gets the current date.

```bash
date +%Y-%m-%d
```

---

# Log Analysis Flow

```text
Log File
   ↓
Validate Input
   ↓
Count Total Lines
   ↓
Find ERROR / Failed
   ↓
Find CRITICAL Events
   ↓
Extract ERROR Messages
   ↓
awk Processing
   ↓
sort
   ↓
uniq -c
   ↓
sort -rn
   ↓
head -5
   ↓
Generate Report
```

---

# Troubleshooting Approach

If the script does not work, I would check:

### 1. Check whether the argument was provided

```bash
./log_analyzer.sh
```

### 2. Check whether the log exists

```bash
ls -l sample_log.log
```

### 3. Check script permissions

```bash
ls -l log_analyzer.sh
```

### 4. Make the script executable

```bash
chmod +x log_analyzer.sh
```

### 5. Run the script manually

```bash
./log_analyzer.sh sample_log.log
```

### 6. Check the generated report

```bash
cat log_report_$(date +%Y-%m-%d).txt
```

---

# What I Learned – 3 Key Points

1. **`grep` is extremely useful for log analysis** because it can quickly find errors, failures, and critical events.

2. **Linux commands can be chained together using pipes** to build powerful data-processing workflows.

3. **`awk`, `sort`, `uniq`, and `head` can turn raw log data into useful summaries**, which is important for DevOps troubleshooting and automation.

---

# Day 20 Takeaway

Today I built a practical Bash log analyzer instead of manually searching through a log file.

The script follows this pattern:

```text
Input
  ↓
Validation
  ↓
Analysis
  ↓
Filtering
  ↓
Sorting
  ↓
Report Generation
```

This is a useful pattern for building future DevOps automation scripts that analyze logs, monitor systems, and generate reports.

---

# Submission Checklist

- [ ] `log_analyzer.sh`
- [ ] `log_report_<date>.txt`
- [ ] `day-20-solution.md`
- [ ] Test script with `sample_log.log`
- [ ] Verify error count
- [ ] Verify critical events
- [ ] Verify top 5 errors
- [ ] Verify generated report
- [ ] Commit changes
- [ ] Push to GitHub

---

# Learn in Public

Today I built a Bash-based log analyzer that uses `grep`, `awk`, `sort`, `uniq`, and `head` to analyze system logs and generate a summary report.

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
