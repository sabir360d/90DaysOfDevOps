#!/bin/bash

# --------------------------------------------------
# Maintenance Script - DevOps Day 19
# Performs:
#   1. Log rotation (gzip old logs, delete old archives)
#   2. Server backup (tar.gz)
# Logs all output with timestamps
# --------------------------------------------------

# -----------------------------
# CONFIGURATION
# -----------------------------

# Paths - Update these if your directories move
PROJECT_DIR="/root/90DaysOfDevOps/2026/day-19/backup"
LOG_DIR="$PROJECT_DIR"                        # Log rotation target
SOURCE_DIR="$PROJECT_DIR/data"               # Source to backup
BACKUP_DIR="$PROJECT_DIR/backups"            # Backup destination

# Log file location
if [ "$(id -u)" -eq 0 ]; then
    LOG_FILE="/var/log/maintenance.log"     # root user logs
else
    LOG_FILE="$PROJECT_DIR/maintenance.log" # non-root logs
fi

# -----------------------------
# FUNCTIONS
# -----------------------------

# Log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

# -----------------------------
# START SCRIPT
# -----------------------------
log_message "===== Maintenance Job Started ====="

# -----------------------------
# LOG ROTATION
# -----------------------------
log_message "Starting log rotation..."
if [ -d "$LOG_DIR" ]; then
    # Compress .log files older than 7 days
    find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec gzip {} \;

    # Delete .gz files older than 30 days
    find "$LOG_DIR" -type f -name "*.gz" -mtime +30 -delete

    log_message "Log rotation completed successfully."
else
    log_message "ERROR: Log directory not found: $LOG_DIR"
fi

# -----------------------------
# BACKUP
# -----------------------------
log_message "Starting backup..."
if [ -d "$SOURCE_DIR" ]; then

    mkdir -p "$BACKUP_DIR" # Ensure backup directory exists

    timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
    archive_name="backup-${timestamp}.tar.gz"
    archive_path="${BACKUP_DIR}/${archive_name}"

    # Create backup
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
    log_message "ERROR: Source directory not found: $SOURCE_DIR"
fi

log_message "===== Maintenance Job Finished ====="
echo "" >> "$LOG_FILE"

exit 0

