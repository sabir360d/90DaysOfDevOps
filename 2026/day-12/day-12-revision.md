# Day 12 – Breather & Revision (Days 01–11)

## Goal
Consolidate core Linux fundamentals learned in Days 01–11
---
## 1.  Mindset & Learning Plan Review (Day 01)

**Original Goal (Day 01):**
- Build strong Linux fundamentals for DevOps
- Understand processes, services, users, and permissions

**Current Reflection:**
- Goals are still relevant and aligned
- Confidence with basic commands has improved
- Permissions and service troubleshooting need practice

**Tweaks Going Forward:**
- Spend more time on `chmod` (numeric modes)
- Practice reading logs daily using `journalctl`

## 2. Processes & Services Review (Days 04–05)

### Command 1: Process Check
ps aux | head

## Observation:
1. Confirmed multiple system processes run as root
2. USER, PID, and %CPU columns are critical during incidents

### Command 2: Service Status
systemctl status ssh

## Observation:
1. Service is active and enabled
2. Clear visibility into uptime and recent logs

## 3. File Skills Practice (Days 06–11)
## File Operations Performed
1. Append text to a file:
echo "Revision practice" >> notes.txt

2. Change permissions:
chmod 644 notes.txt

3. Verify permissions:
ls -l notes.txt

# Key Takeaway:
1. Always verify changes using ls -l
2. Small permission mistakes can block access

## 4. Cheat Sheet Refresh (Day 03)
## Top 5 Commands I’d Use First in an Incident
1. top – identify CPU or memory spikes
2. ps aux – confirm running processes
3. df -h – check disk space issues
4. journalctl -xe – view recent critical logs
5. systemctl status <service> – verify service health

## Why these matter:
They quickly answer:
1. Is the system overloaded?
2. Is the service running?
3. Are logs showing failures?

## 5. User & Group Sanity Check (Days 09-11)
## Scenario: Create a User and Verify
sudo useradd professor
id professor

## Verification:
1. User created successfully
2. UID and GID assigned correctly

## Ownership Change Test
sudo chown devtest:devtest notes.txt
ls -l notes.txt

# Result:
1. Ownership updated correctly
2. Permissions remain intact

## 6.  Mini Self-Check
1. Three commands that save me the most time
ls -l – instant permission and ownership clarity
systemctl status – fast service health check
journalctl -u <service> – direct log access

2. How to check if a service is healthy
systemctl status nginx
journalctl -u nginx --no-pager | tail
ps aux | grep nginx

3. Safely changing ownership and permissions
Example:
sudo chown ubuntu:ubuntu app.log
chmod 640 app.log

## Why safe:
1. Ownership assigned explicitly
2. Permissions allow owner/group access without exposing to others

4. Focus for the Next 3 Days
Master numeric chmod values
Read logs faster and more confidently
Reduce reliance on notes for basic commands

## Key Takeaways (Day 12)
1. Repetition builds confidence
2. Verification (ls -l, id, status) is non-negotiable
3. Logs are your best debugging friend
4. Slow, consistent progress beats rushing ahead
