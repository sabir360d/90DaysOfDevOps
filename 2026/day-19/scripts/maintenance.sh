#!/bin/bash

# --------------------------------------------------
# Maintenance Script
# Runs:
#   1. Log rotation
#   2. Server backup
# Logs all output with timestamps to:
#   /var/log/maintenance.log
# --------------------------------------------------

LOG_FILE="/var/log/maintenance.log"

LOG_DIR="/var/log/myapp"
SOURCE_DIR="/var/www"
BACKUP_DIR="/backups"

# Function to print timestamped logs
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

# Redirect all output (stdout + stderr) to log file
exec >> "$LOG_FILE" 2>&1

log_message "===== Maintenance Job Started ====="

# -----------------------------
# Log Rotation Section
# -----------------------------
log_message "Starting log rotation..."

if [ -d "$LOG_DIR" ]; then
    find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec gzip {} \;
    find "$LOG_DIR" -type f -name "*.gz" -mtime +30 -delete
    log_message "Log rotation completed successfully."
else
    log_message "ERROR: Log directory not found."
fi

# -----------------------------
# Backup Section
# -----------------------------
log_message "Starting backup..."

if [ -d "$SOURCE_DIR" ]; then

    timestamp=$(date '+%Y-%m-%d')
    archive_name="backup-${timestamp}.tar.gz"
    archive_path="${BACKUP_DIR}/${archive_name}"

    mkdir -p "$BACKUP_DIR"

    tar -czf "$archive_path" -C "$SOURCE_DIR" . 

    if [ $? -eq 0 ]; then
        size=$(du -h "$archive_path" | cut -f1)
        log_message "Backup successful: ${archive_name} (${size})"
    else
        log_message "ERROR: Backup failed."
    fi

    # Delete backups older than 14 days
    find "$BACKUP_DIR" -type f -name "backup-*.tar.gz" -mtime +14 -delete
    log_message "Old backups cleanup completed."

else
    log_message "ERROR: Source directory not found."
fi

log_message "===== Maintenance Job Finished ====="
echo "" >> "$LOG_FILE"

exit 0

