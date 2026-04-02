#!/bin/bash

# --------------------------------------------------
# Server Backup Script
# Usage:
# ./backup.sh <source_directory> <backup_destination>
#
# This script:
# 1. Creates a timestamped .tar.gz archive
# 2. Verifies archive creation
# 3. Prints archive name and size
# 4. Deletes backups older than 14 days
# 5. Exits with error if source doesn't exist
# --------------------------------------------------

# Function to display usage
display_usage() {
    echo "Usage: ./backup.sh <source_directory> <backup_destination>"
}

# Check if exactly 2 arguments are provided
if [ $# -ne 2 ]; then
    display_usage
    exit 1
fi

source_dir=$1
backup_dir=$2

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory '$source_dir' does not exist."
    exit 1
fi

# Create backup destination if it does not exist
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
fi

# Create timestamp (Format: YYYY-MM-DD)
timestamp=$(date '+%Y-%m-%d')

# Archive name
archive_name="backup-${timestamp}.tar.gz"
archive_path="${backup_dir}/${archive_name}"

# Function to create backup
create_backup() {

    # Create compressed tar archive
    tar -czf "$archive_path" -C "$source_dir" . 2>/dev/null

    # Verify if archive was created successfully
    if [ $? -eq 0 ] && [ -f "$archive_path" ]; then
        echo "Backup created successfully."

        # Get archive size
        size=$(du -h "$archive_path" | cut -f1)

        echo "Archive Name: $archive_name"
        echo "Archive Size: $size"
    else
        echo "Error: Backup failed."
        exit 1
    fi
}

# Function to delete backups older than 14 days
perform_rotation() {

    old_backups=$(find "$backup_dir" -type f -name "backup-*.tar.gz" -mtime +14)

    for file in $old_backups; do
        rm -f "$file"
    done
}

# Call functions
create_backup
perform_rotation

exit 0

