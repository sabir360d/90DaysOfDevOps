# Day 70 — Variables, Facts, Conditionals and Loops

# Task 1: Variables in Playbooks
- Create variables-demo.yml: 

## Verification

* Playbook executed successfully across all hosts
* Directory `/opt/terraweek-app` created
* Packages installed using `package` module

## CLI Override Test

```bash
ansible-playbook variables-demo.yml
```

### Observation

* CLI variables **override playbook variables**



---

# Task 2: group_vars and host_vars

- Variables should not live inside playbooks. Move them to dedicated files.

- Project Structure:

screenshot

## Variable Files:

### group_vars/all.yml
* Common variables applied to all hosts

### group_vars/web.yml
* Applied only to `web` group

### group_vars/db.yml
* Applied only to `db` group

### host_vars/web1.yml
* Applied only to `web1`

---

## Playbook Execution Output Highlights

```text
HTTP port: 80, Max connections: 2000
This is the primary web server
```

---

## Observations

* Variables from `group_vars/all.yml` applied to all hosts
* Variables from `group_vars/web.yml` applied only to web servers
* `web1` used `max_connections = 2000` (from host_vars)
* Host-specific variable `custom_message` worked correctly
* `app1` and `db1` did not run web-specific tasks

---

## Variable Precedence

Order (low → high):

```
group_vars/all
< group_vars/<group>
< host_vars/<host>
< playbook vars
< task vars
< extra vars (-e)
```

### Example:

* `group_vars/web.yml` → `max_connections: 1000`
* `host_vars/web1.yml` → `max_connections: 2000`

---

#  Task 3: Ansible Facts

## Commands Used

```bash
ansible web -m setup
ansible web -m setup -a "filter=ansible_distribution"
ansible web -m setup -a "filter=ansible_memtotal_mb"
```

---

## Example Output

```text
OS: Amazon 2023
IP: 172.31.x.x
RAM: 916MB
```

---

## Useful Facts

* `ansible_distribution` → OS detection
* `ansible_distribution_version` → version control
* `ansible_memtotal_mb` → memory checks
* `ansible_default_ipv4.address` → networking
* `ansible_hostname` → host identification

---

# Task 4: Conditionals

## Key Features Used

* Group-based conditions:

  ```yaml
  when: "'web' in group_names"
  ```

* OS-based condition:

  ```yaml
  when: ansible_distribution == "Amazon"
  ```

* Memory condition:

  ```yaml
  when: ansible_memtotal_mb < 1024
  ```

---

## Observations

* Nginx installed only on web servers
* MySQL installed only on db servers
* Low memory warning triggered (<1GB RAM)
* Tasks skipped correctly when conditions not met

---

# Task 5: Loops

## Loop Implementation

* Created multiple users
* Created multiple directories
* Installed multiple packages
* Printed results per iteration

---

## Example Output

```text
(item={'name': 'deploy', 'groups': 'wheel'})
(item={'name': 'monitor', 'groups': 'wheel'})
(item={'name': 'appuser', 'groups': 'users'})
```

---

## Loop vs with_items

* `loop` is the modern and recommended method
* `with_items` is deprecated

### Differences:

* `loop` is more flexible and readable
* Supports all data types
* Replaces older constructs like:

  * with_items
  * with_dict
  * with_list

### Conclusion:

* Always use `loop` in modern Ansible playbooks

---

#  Task 6: Server Health Report

## Features Used

* `register` to capture command output
* `debug` to display structured report
* `when` for disk alerts
* `copy` to save report to file

---

## Sample Output

```text
========== web1 ==========
OS: Amazon 2023
IP: 172.31.28.15
RAM: 916MB
Disk: /dev/nvme0n1p1  8.0G  1.7G  6.3G  22% /
Running services: 20
```

---

## File Verification

```bash
cat /tmp/server-report-*.txt
```

### Output:

```
Server: web1
OS: Amazon 2023
IP: 172.31.28.15
RAM: 916MB
Disk: Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p1  8.0G  1.7G  6.3G  22% /
Checked at: 2026-04-10T06:49:00Z
```

---

## Verification

* Hostname matches inventory
* OS matches Ansible facts
* IP matches EC2 private IP
* Memory matches system memory
* Disk usage matches `df -h`
* Timestamp generated correctly

---

# Final Outcome

* Dynamic infrastructure using variables ✅
* Environment-aware execution using facts ✅
* Conditional automation using `when` ✅
* Efficient repetition using loops ✅
* Real-time system reporting with register ✅

---

