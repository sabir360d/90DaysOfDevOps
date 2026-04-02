#!/bin/bash

# ==========================================
# Day 20 - Log Analyzer & Report Generator
# ==========================================

# -------- Task 1: Input & Validation --------

if [ "$#" -ne 1 ]; then
    echo "Usage: ./log_analyzer.sh <log_file_path>"
    exit 1
fi

log_file="$1"

if [ ! -f "$log_file" ]; then
    echo "Error: File does not exist."
    exit 1
fi

echo "Analyzing log file: $log_file"
echo "----------------------------------"

# Get today's date
today=$(date +%Y-%m-%d)
report_file="log_report_$today.txt"

# Total lines processed
total_lines=$(wc -l < "$log_file")

# -------- Task 2: Error Count --------

error_count=$(grep -E "ERROR|Failed" "$log_file" | wc -l)

echo "Total ERROR / Failed entries: $error_count"

# -------- Task 3: Critical Events --------

echo
echo "--- Critical Events ---"
critical_events=$(grep -n "CRITICAL" "$log_file")

if [ -z "$critical_events" ]; then
    echo "No critical events found."
else
    echo "$critical_events"
fi

# -------- Task 4: Top 5 Error Messages --------

echo
echo "--- Top 5 Error Messages ---"

top_errors=$(grep "ERROR" "$log_file" \
    | awk '{$1=$2=$3=""; print $0}' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -5)

if [ -z "$top_errors" ]; then
    echo "No ERROR messages found."
else
    echo "$top_errors"
fi

# -------- Task 5: Generate Summary Report --------

{
echo "========================================="
echo "        LOG ANALYSIS REPORT"
echo "========================================="
echo "Date of Analysis: $today"
echo "Log File: $log_file"
echo "Total Lines Processed: $total_lines"
echo "Total ERROR / Failed Count: $error_count"
echo
echo "----- Top 5 Error Messages -----"
echo "$top_errors"
echo
echo "----- Critical Events -----"
if [ -z "$critical_events" ]; then
    echo "No critical events found."
else
    echo "$critical_events"
fi
} > "$report_file"

echo
echo "Report generated: $report_file"

# -------- Task 6 (Optional): Archive --------

mkdir -p archive
mv "$log_file" archive/

echo "Log file moved to archive/"
echo "Analysis complete."

