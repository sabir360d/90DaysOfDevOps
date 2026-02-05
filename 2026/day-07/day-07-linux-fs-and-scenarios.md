# Day 07 – Linux File System Hierarchy & Scenario-Based Practice

## Part 1: Linux File System Hierarchy

### Core Directories

**/** (root)  
- The top-level directory containing all other files and directories.  
- Example files/folders: `bin`, `etc`, `home`  
- *I would use this when exploring the system structure or mounting disks.*

**/home**  
- Contains user home directories for non-root users.  
- Example: `/home/ubuntu`, `/home/user1`  
- *I would use this when managing user files or SSH access.*

**/root**  
- Home directory of the root user.  
- Example: `/root/.bashrc`, `/root/.ssh`  
- *I would use this when performing administrative tasks.*

**/etc**  
- Stores system-wide configuration files.  
- Example: `/etc/hostname`, `/etc/ssh/sshd_config`  
- *I would use this when configuring services or system settings.*

**/var/log**  
- Contains system and application log files.  
- Example: `/var/log/syslog`, `/var/log/auth.log`  
- *I would use this when troubleshooting errors or auditing activity.*

**/tmp**  
- Temporary files, usually cleared on reboot.  
- Example: `/tmp/testfile`, `/tmp/session1234`  
- *I would use this for temporary storage during scripts or installations.*

### Additional Directories

**/bin**  
- Essential command binaries needed for single-user mode or recovery.  
- Example: `/bin/ls`, `/bin/cat`  
- *I would use this when executing critical commands.*

**/usr/bin**  
- Standard user command binaries.  
- Example: `/usr/bin/python3`, `/usr/bin/git`  
- *I would use this when running user applications.*

**/opt**  
- Optional or third-party software packages.  
- Example: `/opt/google`, `/opt/docker`  
- *I would use this when installing external applications.*

### Hands-On practiced task:

### Find the largest log files

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
# Identifies large log files that may consume disk space
```

### View system hostname

```bash
cat /etc/hostname
# Displays the system hostname
```

### Inspect current user home directory

```bash
ls -la ~
# Lists all files including hidden ones
```

---
## Scenario 1: Service Not Starting

### Problem
```bash
# A web application service called 'myapp' failed to start after a server reboot. What commands would you run to diagnose the issue? Write at least 4 commands in order.
```

### Step 1: Check service status

```bash
systemctl status myapp
# Verifies if the service is running, failed, or stopped
```

### Step 2: List all services (if unsure)

```bash
systemctl list-units --type=service
# Confirms whether the service exists
```

### Step 3: Check if service starts on boot

```bash
systemctl is-enabled myapp
# Determines auto-start behavior after reboot
```

### Step 4: Inspect recent service logs

```bash
journalctl -u myapp -n 50
# Shows recent log entries for troubleshooting
```
---

### Scenario 2: High CPU Usage

### Problem
```bash
# Your manager reports that the application server is slow.
You SSH into the server. What commands would you run to identify
which process is using high CPU?
```
### Steps:
1. View live CPU usage:
```bash
top
# Live which processes are consuming CPU usage
```

2. Alternative interactive view of CPUU usage:
```bash
htop
# Enhanced interactive process viewer. Easier to sort and identify processes
```

3. List top CPU-consuming processes:
```bash
ps aux --sort=-%cpu | head -10
# Snapshot of top CPU-consuming processes, indentify problem causing PID quickly
```

---

## Scenario 3: Finding Service Logs

### Problem
```bash
# A developer asks: "Where are the logs for the 'docker' service?"
The service is managed by systemd.
What commands would you use?
```
### Steps:
1. Check service status

```bash
systemctl status docker
# Confirms service state
```
2. View recent logs

```bash
journalctl -u docker -n 50
# Displays the last 50 log entries
```

3. Follow logs in real-time

```bash
journalctl -u docker -f
# Useful for live troubleshooting
```

---

## Scenario 4: File Permissions Issue

### Problem:
```bash
# A script at /home/user/backup.sh is not executing.
When you run it: ./backup.sh
You get: "Permission denied"

What commands would you use to fix this?
```

### Steps:
1. Check current permissions

```bash
ls -l /home/user/backup.sh
# Look for: -rw-r--r-- (notice no 'x' = not executable)
```

2. Add execute permission

```bash
chmod +x /home/user/backup.sh
# Makes the script executable
```

3. Verify permission change

```bash
ls -l /home/user/backup.sh
# Look for: -rwxr-xr-x (notice 'x' = executable)
```

4. Run the script

```bash
./backup.sh
# Script should now execute successfully
```
