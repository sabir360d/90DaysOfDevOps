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

function display_usage {
    echo "Usage: ./log_rotate.sh <log_directory>"
}

# Check if argument is provided
if [ $# -ne 1 ]; then
    display_usage
    exit 1
fi

log_dir=$1

# Check if directory exists
if [ ! -d "$log_dir" ]; then
    echo "Error: Directory '$log_dir' does not exist."
    exit 1
fi

compressed_count=0
deleted_count=0

function compress_logs {

    # Find .log files older than 7 days (not already compressed)
    old_logs=$(find "$log_dir" -type f -name "*.log" -mtime +7)

    for file in $old_logs; do
        gzip "$file"
        if [ $? -eq 0 ]; then
            ((compressed_count++))
        fi
    done
}

function delete_old_archives {

    # Find .gz files older than 30 days
    old_archives=$(find "$log_dir" -type f -name "*.gz" -mtime +30)

    for file in $old_archives; do
        rm -f "$file"
        if [ $? -eq 0 ]; then
            ((deleted_count++))
        fi
    done
}

compress_logs
delete_old_archives

echo "Compressed files: $compressed_count"
echo "Deleted files: $deleted_count"

exit 0

