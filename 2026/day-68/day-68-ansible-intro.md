Below is a **clean, task-wise, well-documented** version of your assignment using:

* **Ubuntu 22.04**
* **Manual EC2 launch (Option B)**
* **3 instances (web, app, db)**
* **t3.micro (free tier eligible on Amazon Web Services)**
* Includes **SSH key creation**, **Ansible setup**, and **inventory**

You can copy this directly as your submission.

---

# 📘 `day-68-ansible-intro.md`

---

# Day 68 — Introduction to Ansible and Inventory Setup (Manual EC2)

---

## 🧠 Task 1: Understanding Ansible

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
| Ansible | ❌ No           | YAML     | Push      |
| Chef    | ✅ Yes          | Ruby     | Pull      |
| Puppet  | ✅ Yes          | DSL      | Pull      |
| Salt    | ✅ Mostly       | YAML     | Push/Pull |

👉 Ansible is simpler and agentless.

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

# ☁️ Task 2: Set Up Lab (Manual AWS EC2)

## Step 1: Create SSH Key Pair (VERY IMPORTANT)

### Option A: Create via AWS Console

1. Go to EC2 → **Key Pairs**
2. Click **Create Key Pair**
3. Settings:

   * Name: `ansible-key`
   * Type: RSA
   * Format: `.pem`
4. Download file → `ansible-key.pem`

---

### 🔐 Set Permissions (on your machine)

```bash
chmod 400 ansible-key.pem
```

---

### Option B: Create Key Locally (Recommended for learning)

```bash
ssh-keygen -t rsa -b 4096 -f ansible-key
```

This creates:

* `ansible-key` (private key)
* `ansible-key.pub` (public key)

👉 Upload the **public key** to AWS manually if needed.

---

## Step 2: Launch 3 EC2 Instances

Go to EC2 → **Launch Instance**

### Common Configuration for ALL 3:

* **AMI:** Ubuntu Server 22.04 LTS
* **Instance Type:** t3.micro
* **Key Pair:** `ansible-key`
* **Network:** Default VPC

---

## 🔥 Security Group (Important)

Create a new security group:

### Rules:

| Type | Port | Source                |
| ---- | ---- | --------------------- |
| SSH  | 22   | 0.0.0.0/0 (temporary) |
| HTTP | 80   | 0.0.0.0/0             |

👉 For better security later:
Use **your IP instead of 0.0.0.0/0**

---

## Step 3: Name Your Instances

| Instance   | Name Tag   | Role |
| ---------- | ---------- | ---- |
| Instance 1 | web-server | Web  |
| Instance 2 | app-server | App  |
| Instance 3 | db-server  | DB   |

---

## Step 4: Get Public IPs

After launch, copy:

```bash
WEB_IP=
APP_IP=
DB_IP=
```

---

## Step 5: SSH Into Each Instance

```bash
ssh -i ansible-key.pem ubuntu@<WEB_IP>
ssh -i ansible-key.pem ubuntu@<APP_IP>
ssh -i ansible-key.pem ubuntu@<DB_IP>
```

✅ Verify you can log in successfully.

---

# ⚙️ Task 3: Install Ansible (Control Node)

👉 Use your **local machine** or one EC2 as control node

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

### 📌 Why only control node?

Because Ansible is **agentless** — it uses SSH to connect.

---

# 📁 Task 4: Create Inventory

```bash
mkdir ansible-practice
cd ansible-practice
nano inventory.ini
```

---

### inventory.ini

```ini
[web]
web ansible_host=<WEB_IP>

[app]
app ansible_host=<APP_IP>

[db]
db ansible_host=<DB_IP>

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/ansible-key.pem
```

---

## Test Connectivity

```bash
ansible all -i inventory.ini -m ping
```

### Expected Output:

```json
"ping": "pong"
```

---

## 🛠️ Troubleshooting

* Wrong user? → use `ubuntu`
* Key issue? → `chmod 400 ansible-key.pem`
* SSH blocked? → check security group

---

# 🚀 Task 5: Ad-Hoc Commands

---

### 1. Check uptime

```bash
ansible all -m command -a "uptime"
```

---

### 2. Check memory (web only)

```bash
ansible web -m command -a "free -h"
```

---

### 3. Check disk

```bash
ansible all -m command -a "df -h"
```

---

### 4. Install Git

```bash
ansible web -m apt -a "name=git state=present" --become
```

---

### 5. Copy file

```bash
echo "Hello from Ansible" > hello.txt
ansible all -m copy -a "src=hello.txt dest=/tmp/hello.txt"
```

---

### 6. Verify file

```bash
ansible all -m command -a "cat /tmp/hello.txt"
```

---

# 🔐 What Does `--become` Do?

* Acts like `sudo`
* Gives root privileges

### Needed for:

* Installing packages
* Managing services
* Writing to system directories

---

# 🧩 Task 6: Inventory Groups

---

### Update inventory.ini

```ini
[application:children]
web
app

[all_servers:children]
application
db
```

---

### Test Groups

```bash
ansible application -m ping
ansible db -m ping
ansible all_servers -m ping
```

---

### Patterns

```bash
ansible 'web:app' -m ping
ansible 'all:!db' -m ping
```

---

# ⚙️ ansible.cfg

```bash
nano ansible.cfg
```

```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/ansible-key.pem
```

---

### Now run:

```bash
ansible all -m ping
```

---

# ⚖️ Command vs Shell Module

| Feature   | command | shell  |
| --------- | ------- | ------ |
| Safe      | ✅ Yes   | ❌ Less |
| Pipes     | ❌ No    | ✅ Yes  |
| Redirects | ❌       | ✅      |

---

### Example:

```bash
ansible all -m shell -a "df -h | grep /dev"
```

---

# ✅ Final Outcome

* 3 Ubuntu EC2 instances created
* SSH access configured
* Ansible installed
* Inventory configured
* Ad-hoc commands executed successfully

---

# 🧹 Cleanup Reminder

Terminate instances from EC2 console to avoid charges.

---

# 🚀 Next Step

Day 69:

* Write your first **Ansible Playbook**
* Automate Nginx deployment on web server

---

If you want, I can **review your actual inventory or debug your ping errors** — that’s usually where beginners get stuck.

