#!/bin/bash

# Check if a log file was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log-file>"
    exit 1
fi

LOG_FILE="$1"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file does not exist: $LOG_FILE"
    exit 1
fi

DATE=$(date +%Y-%m-%d)
REPORT="log_report_${DATE}.txt"

# Count total lines
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# Count lines containing ERROR or Failed
ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

# Find critical events with line numbers
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE")

# Find top 5 most common ERROR messages
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

# Generate summary report
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
