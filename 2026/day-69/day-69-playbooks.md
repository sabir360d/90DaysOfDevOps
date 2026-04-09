# Day 69 — Ansible Playbooks & Modules 

## Overview

Ad-hoc commands are useful for quick checks, but real automation lives in playbooks. A playbook is a YAML file that describes the desired state of your servers -- which packages to install, which services to run, which files to place where. You write it once, run it a hundred times, and get the same result every time.

## 1. First Playbook (Annotated)

### `install-nginx.yml`

```yaml
---                                # YAML document start

- name: Install and start Nginx    # PLAY (targets a group)
  hosts: web                       # Inventory group
  become: true                     # Run as root (sudo)

  tasks:                           # List of tasks
    - name: Install Nginx          # TASK
      apt:                         # MODULE (use yum for Amazon Linux)
        name: nginx
        state: present             # Ensure installed

    - name: Start and enable Nginx
      service:
        name: nginx
        state: started             # Ensure running
        enabled: true              # Start on boot

    - name: Create custom index page
      copy:
        content: "<h1>Deployed by Ansible - TerraWeek Server</h1>"
        dest: /usr/share/nginx/html/index.html
```

---

## Key Concepts

### Play vs Task

* **Play** → Targets a group of hosts
* **Task** → A single unit of work (e.g., install package)

### Multiple Plays?

✅ Yes — one playbook can target multiple server groups

### `become: true`

* **Play level** → applies to all tasks
* **Task level** → applies only to that task

### Task Failure Behavior

* Play **stops on failure** by default for that host
* Other hosts continue execution

---

## 2. Essential Modules

### `essential-modules.yml`

```yaml
---
- name: Practice essential modules
  hosts: all
  become: true

  tasks:
    - name: Install packages
      apt:
        name:
          - git
          - curl
          - wget
          - tree
        state: present

    - name: Ensure Nginx running
      service:
        name: nginx
        state: started
        enabled: true

    - name: Copy config file
      copy:
        src: files/app.conf
        dest: /etc/app.conf
        owner: root
        group: root
        mode: '0644'

    - name: Create app directory
      file:
        path: /opt/myapp
        state: directory
        owner: ubuntu
        mode: '0755'

    - name: Check disk space
      command: df -h
      register: disk_output

    - name: Show disk output
      debug:
        var: disk_output.stdout_lines

    - name: Count processes
      shell: ps aux | wc -l
      register: process_count

    - name: Show process count
      debug:
        msg: "Total processes: {{ process_count.stdout }}"

    - name: Set timezone
      lineinfile:
        path: /etc/environment
        line: 'TZ=UTC'
        create: true
```

---

## Command vs Shell

| Feature         | command       | shell          |   |
| --------------- | ------------- | -------------- | - |
| Shell support   | ❌ No          | ✅ Yes          |   |
| Pipes (`        | `)            | ❌              | ✅ |
| Redirects (`>`) | ❌             | ✅              |   |
| Safety          | ✅ More secure | ⚠️ Less secure |   |

**Rule:**

* Use `command` → default
* Use `shell` → only when needed

---

## 3. Handlers (Efficient Restarts)

### `nginx-config.yml`

```yaml
---
- name: Configure Nginx
  hosts: web
  become: true

  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Deploy config
      copy:
        src: files/nginx.conf
        dest: /etc/nginx/nginx.conf
      notify: Restart Nginx

    - name: Ensure running
      service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

### Behavior

* **First run:** handler runs ✅
* **Second run:** handler skipped ❌

➡️ Only triggers when a change occurs

---

## 4. Idempotency Proof

### First Run

```
TASK [Install Nginx] → changed
TASK [Start Nginx] → changed
```

### Second Run

```
TASK [Install Nginx] → ok
TASK [Start Nginx] → ok
```

✅ No unnecessary changes
✅ Safe to run repeatedly

---

## 5. Dry Run, Diff, Verbosity

### Commands

```bash
# Dry run
ansible-playbook install-nginx.yml --check

# Show changes
ansible-playbook nginx-config.yml --check --diff

# Debugging
ansible-playbook install-nginx.yml -vvv

# Limit hosts
ansible-playbook install-nginx.yml --limit web

# Preview execution
ansible-playbook install-nginx.yml --list-hosts
ansible-playbook install-nginx.yml --list-tasks
```

### Why `--check --diff` Matters

* Prevents breaking production
* Shows **exact changes before applying**
* Enables safe reviews and approvals

---

## 6. Multiple Plays

### `multi-play.yml`

```yaml
---
- name: Web servers
  hosts: web
  become: true
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

- name: App servers
  hosts: app
  become: true
  tasks:
    - name: Install dependencies
      apt:
        name:
          - gcc
          - make
        state: present

- name: DB servers
  hosts: db
  become: true
  tasks:
    - name: Install MySQL client
      apt:
        name: mysql-client
        state: present
```

---

## Key Takeaways

* Playbooks = **declarative infrastructure**
* Idempotency = **safe repeatability**
* Modules = **building blocks of automation**
* Handlers = **efficient change management**
* `--check --diff` = **production safety net**

---

## Folder Structure

```
day-69/
├── install-nginx.yml
├── essential-modules.yml
├── nginx-config.yml
├── multi-play.yml
└── files/
    ├── app.conf
    └── nginx.conf
```

---

## Final Thoughts

Today was a major shift from **manual execution → automated infrastructure**.

Ansible playbooks are:

* Reusable
* Predictable
* Production-ready

---