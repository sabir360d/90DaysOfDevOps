# Day 08 – Cloud Server Setup: Nginx Web Deployment

## Objective
Deploy a real web server on a cloud VM, expose it securely to the internet, and collect service logs — simulating a real production DevOps workflow.

## Cloud Environment
- Provider: AWS EC2
- OS: Ubuntu 22.04 LTS
- Instance Type: t3.micro
- SSH Tool: PuTTY (Windows)
- Web Server: Nginx

## Part 1: Launch Cloud Instance & SSH Access

### Step 1: Create EC2 Instance
- Launched an EC2 instance with Ubuntu
- Created a .ppk key pair
- Configured Security Group:
  - SSH (22) => My IP
  - HTTP(80) => 0.0.0.0/0

### Step 2: Connect via SSH
Used PuTTY with `.ppk` private key to connect to the instance.

**Screenshot:** `ssh-connection.png`
![image alt](https://github.com/sabir360d/90DaysOfDevOps/blob/3f1ca8d9a6a348051e7e2dc561a063ed7aafb338/2026/day-08/putty-login.JPG)

### Part 2: Install Nginx

sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl status nginx

**Nginx service was running successfully.**

### Part 3: Security Group Configuration & Web Access

Ensured port 80 (HTTP) was open in the EC2 Security Group
Accessed the public IP from a browser:
http://<EC2-PUBLIC-IP>

**Nginx welcome page loaded successfully**

**Screenshot:** `nginx-webpage.png`
![image alt](https://github.com/sabir360d/90DaysOfDevOps/blob/3f1ca8d9a6a348051e7e2dc561a063ed7aafb338/2026/day-08/nginx.JPG)

### Part 4: Extract Nginx Logs

- Step 1: View Logs
    sudo tail /var/log/nginx/access.log
    sudo tail /var/log/nginx/error.log

- Step 2: Save Logs to File
    sudo cat /var/log/nginx/access.log > ~/nginx-logs.txt

**Screenshot:** `nginx-log.png`
![image alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-08/nginx-logs-ubuntu.JPG)

- Step 3: Download Logs to Local Machine (PuTTY / .ppk)
Using Windows PowerShell PSCP (PuTTY SCP client) run the following:
pscp -i your-key.ppk ubuntu@<EC2-PUBLIC-IP>:/home/ubuntu/nginx-logs.txt .

**Log file successfully downloaded.**

To view logs on Local Machine:
notepad nginx-logs.txt

**Screenshot:** `nginx-logs-local.png`
![image alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-08/nginx-logs-windows.JPG)

```bash
Commands Used
1. sudo apt update
2. sudo apt install nginx -y
3. sudo systemctl status nginx
4. sudo cat /var/log/nginx/access.log
5. pscp -i key.ppk ubuntu@<ip>:/home/ubuntu/nginx-logs.txt .
6. notepad nginx-logs.txt
```

Challenges Faced
1. Nginx page not loading initially due to missing HTTP rule
2. Fixed by updating EC2 Security Group to allow port 80
3. Learned how .ppk keys require pscp instead of standard scp

What I Learned
1. How to launch and secure a cloud VM
2. How to install and manage services on Linux
3. How cloud firewalls (Security Groups) control traffic
4. How to access and export application logs
5. How SSH tooling differs between Linux and Windows
6. How to download and view logs on Local Machine
