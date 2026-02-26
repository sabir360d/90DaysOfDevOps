# Day 28 – Revision Day: Everything from Day 1 to Day 27

## Task

Revise everything learned so far.  
Identify weak areas. Strengthen fundamentals.

---

## Self-Assessment Summary

### Linux
- File system navigation – Confident  
- Processes & systemd – Confident  
- Users & permissions – Confident  
- LVM – Confident  
- Networking & subnetting – Confident  

### Shell Scripting
- Variables, loops, conditionals – Confident  
- Functions – More Practice needed
- grep/awk/sed – More practice needed  
- Error handling & crontab – Confident  

### Git & GitHub
- Branching, merging, pushing – Confident  
- Reset vs revert – Clear  
- Rebase & cherry-pick – Confident  
- Branching strategies – Confident  

---

## Topics Revisited

### 1. LVM
- PV → VG → LV structure  
- Resize volumes without repartitioning  
- More flexible than traditional partitions  

### 2. Networking Basics
- CIDR notation (/24 = 256 IPs)  
- Common ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)  

### 3. Git Rebase vs Merge
- Merge keeps full history  
- Rebase creates cleaner linear history  
- Avoid rebasing shared branches  

---

## Quick Answers

- `chmod 755 file.sh` → Owner full access, others read & execute  
- Process vs Service → Process runs; service is managed background process  
- Port 8080 usage → `ss -tulnp | grep 8080`  
- `set -euo pipefail` → Strict error handling in scripts  
- `git reset --hard` vs `git revert` → Reset rewrites history, revert creates undo commit  
- Daily 3 AM cron → `0 3 * * * /path/script.sh`  
- `git fetch` vs `git pull` → Fetch downloads, pull downloads + merges  
- LVM → Flexible storage management  

---

## Teach Back – What Are File Permissions?

Linux permissions control who can read, write, or execute files.

Three levels:
- Owner
- Group
- Others

Example:
`755` =  
- 7 → read, write, execute  
- 5 → read, execute  
- 5 → read, execute  

Permissions protect the system and control access.

---

## Reflection

Strong in Linux basics and Git fundamentals.  
Need more repetition in subnetting and advanced Git workflows.

Revision builds confidence.  
Consistency builds mastery.

