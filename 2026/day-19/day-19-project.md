# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

## Task
Apply shell scripting fundamentals to real-world automation:
- Write a log rotation script
- Write a server backup script
- Schedule them with crontab

---

## Challenge Tasks

### Task 1: Log Rotation Script
Create `log_rotate.sh` that:
1. Takes a log directory as an argument (e.g., `/var/log/myapp`)
2. Compresses `.log` files older than 7 days using `gzip`
3. Deletes `.gz` files older than 30 days
4. Prints how many files were compressed and deleted
5. Exits with an error if the directory doesn't exist

### Solution

- Create five .log files in /var/log/myapp
- Three `.log` files older than 7 days
- Two `.log` files older than 30 days

Script should:
- Compress all .log files older than 7 days
- Delete only .gz files older than 30 days
- Print how many were compressed and deleted
- Exit if directory doesn’t exist

### Script Location
[scripts/log_rotate.sh](./scripts/log_rotate.sh)

### Screenshot Output
[screenshots/log-rotate-output.jpeg](./screenshots/log-rotate-output.jpeg)

---

### Task 2: Server Backup Script
### Create `backup.sh` that:
1. Takes a source directory and backup destination as arguments
2. Creates a timestamped `.tar.gz` archive (e.g., `backup-2026-02-08.tar.gz`)
3. Verifies the archive was created successfully
4. Prints archive name and size
5. Deletes backups older than 14 days from the destination
6. Handles errors — exit if source doesn't exist

### Script Location
[scripts/backup.sh](./scripts/backup.sh)

### Screenshot Output
[screenshots/backup-output.jpeg](./screenshots/backup-output.jpeg)

---

### Task 3: Crontab
1. Read: `crontab -l` — what's currently scheduled?
2. Understand cron syntax:
   ```
   * * * * *  command
   │ │ │ │ │
   │ │ │ │ └── Day of week (0-7)
   │ │ │ └──── Month (1-12)
   │ │ └────── Day of month (1-31)
   │ └──────── Hour (0-23)
   └────────── Minute (0-59)
   ```
3. Write cron entries (in your markdown, don't apply if unsure) for:
   - Run `log_rotate.sh` every day at 2 AM
   - Run `backup.sh` every Sunday at 3 AM
   - Run a health check script every 5 minutes

### View Current Cron Jobs

```bash
crontab -l
```

### Edit cron jobs
```bash
crontab -e
```
### Required Cron Entries

```bash

# Run log rotation every day at 2 AM
0 2 * * * /usr/bin/bash /root/90DaysOfDevOps/2026/day-19/log_rotate.sh /var/log/myapp >> /var/log/log_rotate.log 2>&1

# Run backup every Sunday at 3 AM
0 3 * * 0 /usr/bin/bash /root/90DaysOfDevOps/2026/day-19/backup.sh /var/www /backups >> /var/log/backup.log 2>&1

# Run health check every 5 minutes
*/5 * * * * /usr/bin/bash /root/90DaysOfDevOps/2026/day-19/health_check.sh >> /var/log/health.log 2>&1
```

---

### Task 4: Combine — Scheduled Maintenance Script
### Create `maintenance.sh` that:
1. Calls your log rotation function
2. Calls your backup function
3. Logs all output to `/var/log/maintenance.log` with timestamps
4. Write the cron entry to run it daily at 1 AM

### Script Location
[scripts/maintenance.sh](./scripts/maintenance.sh)

### Screenshot Output
[screenshots/maintenance-output.jpeg](./screenshots/maintenance-output.jpeg)

### Cron Entry – Run Daily at 1 AM

```bash
0 1 * * * /root/90DaysOfDevOps/2026/day-19/maintenance.sh
```

### What I Learned

1. Automation reduces operational risk — Manual backups and log cleanup are failure-prone.
2. Cron is powerful but dangerous — A wrong path or missing permission breaks automation silently.
3. Observability matters — Logging output with timestamps is critical for production troubleshooting.
