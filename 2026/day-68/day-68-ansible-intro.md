# Day 68 — Introduction to Ansible and Inventory Setup
## Task 1: Understanding Ansible

### 1. What is Configuration Management?

Configuration management ensures that servers are:

* Consistent
* Automatically configured
* Maintained in a desired state

### Why we need it:

* Prevent configuration drift
* Automate repetitive setup tasks
* Ensure consistency across environments
* Scale infrastructure efficiently

---

### 2. How Ansible Differs from Chef, Puppet, Salt

| Tool    | Agent Required | Language | Model     |
| ------- | -------------- | -------- | --------- |
| Ansible |   No           | YAML     | Push      |
| Chef    |   Yes          | Ruby     | Pull      |
| Puppet  |   Yes          | DSL      | Pull      |
| Salt    |   Mostly       | YAML     | Push/Pull |

Ansible is agentless and idempotent.

---

### 3. What Does "Agentless" Mean?

* No software installed on managed nodes
* Uses **SSH** to connect and execute tasks

---

### 4. Ansible Architecture

* **Control Node** → where Ansible runs
* **Managed Nodes** → EC2 instances
* **Inventory** → list of servers
* **Modules** → tasks (install, copy, start services)
* **Playbooks** → YAML automation scripts

---

## Task 2: Set Up Your Lab Environment (Manual AWS EC2)

## Instances Label 

| Instance   | Name Tag   | Role |
| ---------- | ---------- | ---- |
| Instance 1 | web-server | Web  |
| Instance 2 | app-server | App  |
| Instance 3 | db-server  | DB   |

---

## Verify you can SSH into each one from your control node:

```bash
ssh -i ansible-key.pem ubuntu@<WEB_IP>
ssh -i ansible-key.pem ubuntu@<APP_IP>
ssh -i ansible-key.pem ubuntu@<DB_IP>
```

---

# Task 3: Install Ansible (Control Node)

### Install:

```bash
sudo apt update
sudo apt install ansible -y
```

### Verify:

```bash
ansible --version
```

---

### Why only control node (web-server)?

Because Ansible is **agentless** — it uses SSH to connect.

---

## Task 4: Create Your Inventory File

```bash
mkdir ansible-practice && cd ansible-practice
vim inventory.ini
```
### inventory.ini

```ini
[web]
web1 ansible_host=<WEB_PUBLIC_IP>

[app]
app1 ansible_host=<APP_PUBLIC_IP>

[db]
db1 ansible_host=<DB_PUBLIC_IP>

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/ansible-key.pem
```
### Test Connectivity

```bash
ansible all -i inventory.ini -m ping
```



---

## Task 5: Run Ad-Hoc Commands
Ad-hoc commands let you run quick one-off tasks without writing a playbook


1. **Check uptime on all servers:**
```bash
ansible all -i inventory.ini -m command -a "uptime"
```

2. **Check free memory on web servers only:**
```bash
ansible web -i inventory.ini -m command -a "free -h"
```

3. **Check disk space on all servers:**
```bash
ansible all -i inventory.ini -m command -a "df -h"
```

4. **Install a package on the web group:**
```bash
ansible web -i inventory.ini -m yum -a "name=git state=present" --become
```
(Use `apt` instead of `yum` if running Ubuntu)

5. **Copy a file to all servers:**
```bash
echo "Hello from Ansible" > hello.txt
ansible all -i inventory.ini -m copy -a "src=hello.txt dest=/tmp/hello.txt"
```

6. **Verify the file was copied:**
```bash
ansible all -i inventory.ini -m command -a "cat /tmp/hello.txt"
```

**Document:** 
### What Does `--become` Do?

* Acts like `sudo`
* Gives root privileges

### Needed for:

* Installing packages
* Managing services
* Writing to system directories

---

## Task 6: Explore Inventory Groups and Patterns
1. **Create a group of groups** -- add this to your `inventory.ini`:
```ini
[application:children]
web
app

[all_servers:children]
application
db
```

2. Run commands against different groups:
```bash
ansible application -i inventory.ini -m ping     # web + app servers
ansible db -i inventory.ini -m ping               # only db server
ansible all_servers -i inventory.ini -m ping      # everything
```

3. **Use patterns:**
```bash
ansible 'web:app' -i inventory.ini -m ping        # OR: web or app
ansible 'all:!db' -i inventory.ini -m ping        # NOT: all except db
```

4. **Create an `ansible.cfg`** to avoid typing `-i inventory.ini` every time:
```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
remote_user = ec2-user
private_key_file = ~/your-key.pem
```

Now you can simply run:
```bash
ansible all -m ping
```

**Verify:** Does `ansible all -m ping` work without specifying the inventory file?


## Summary:

* 3 Ubuntu EC2 instances created
* SSH access configured
* Ansible installed
* Inventory configured
* Ad-hoc commands executed successfully

---

