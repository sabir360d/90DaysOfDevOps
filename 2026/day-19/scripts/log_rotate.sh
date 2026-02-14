#!/bin/bash

<< readme
Log Rotation Script

Usage:
./log_rotate.sh <log_directory>

Description:
- Compresses .log files older than 7 days using gzip
- Deletes .gz files older than 30 days
- Prints number of files compressed and deleted
- Exits with error if directory does not exist
readme

LOG_DIR=$1

# 1. Check if directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR does not exist."
    exit 1
fi

echo "Starting log rotation in: $LOG_DIR"
echo "--------------------------------------"

# 2. Compress .log files older than 7 days
# We find files, compress them, and store the names in a variable for the count
comp_list=$(find "$LOG_DIR" -name "*.log" -type f -mtime +7)
comp_count=0

for file in $comp_list; do
    gzip "$file"
    echo "Compressed: ${file}.gz"
    ((comp_count++))
done

# 3. Delete .gz files older than 30 days
del_list=$(find "$LOG_DIR" -name "*.gz" -type f -mtime +30)
del_count=0

for file in $del_list; do
    rm "$file"
    echo "Deleted: $file"
    ((del_count++))
done

# 4. Print Summary
echo "--------------------------------------"
echo "Compressed files: $comp_count"
echo "deleted files: $del_count"

