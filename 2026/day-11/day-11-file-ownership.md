# Day 11 – File Ownership Challenge (chown & chgrp)
### Task
File and directory ownership in Linux.
Understand file ownership (user and group)
Change file owner using chown
Change file group using chgrp
Apply ownership changes recursively
### Task 1: Understanding File Ownership
File ownership was inspected using the `ls -l` command.
### Permission Format
-rw-r--r-- 1 owner group size date filename
- **Owner**: User who owns the file
- **Group**: Group associated with the file
### Sample Output
-rw-r--r-- 1 ubuntu ubuntu 512 Feb 11 10:12 notes.txt
-rw-r--r-- 1 root root 3271 Feb  6 02:21 day-11-file-ownership.md
### Task 2: Basic chown Operations
### File Created
- `devops-file.txt`
### Commands Used
touch devops-file.txt
ls -l devops-file.txt
sudo chown tokyo devops-file.txt
sudo chown berlin devops-file.txt
ls -l devops-file.txt
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-11/task2.JPG)
### Task 3: Basic chgrp Operations
### File and Group
    File: team-notes.txt
    Group: heist-team
### Commands Used
   touch team-notes.txt
   sudo groupadd heist-team
   sudo chgrp heist-team team-notes.txt
   ls -l team-notes.txt
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-11/task3.JPG) 
### Task 4: Combined Owner and Group Change
### Files and Directories
    project-config.yaml
    app-logs/
### Commands Used
    touch project-config.yaml
    sudo chown professor:heist-team project-config.yaml
    mkdir app-logs
    sudo chown berlin:heist-team app-logs
    ls -l
### Task 5: Recursive Ownership Changes
### 1. Directory Structure
### Commands Used
    mkdir -p heist-project/vault heist-project/plans
    touch heist-project/vault/gold.txt
    touch heist-project/plans/strategy.conf
### 2. Groups created
### Command used
    sudo groupadd planners
### 3. Changed ownership of entire heist-project/ directory:
    Owner: professor
    Group: planners
    Use recursive flag (-R)
### command used
    sudo chown -R professor:planners heist-project/
### 4. Verification of filles and subdirectories:
### command used
    ls -lR heist-project/
 ![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-11/task5.JPG) 
### Task 6: Practice Challenge
    Users: tokyo, berlin, nairobi
    Groups: vault-team, tech-team
    Directory: bank-heist/
        file: access-codes.txt
        file: blueprints.pdf
        file: escape-plan.txt
### Commands Used
    mkdir bank-heist
    touch bank-heist/access-codes.txt
    touch bank-heist/blueprints.pdf
    touch bank-heist/escape-plan.txt
### 5. Set different Owernships:
    sudo chown tokyo:vault-team bank-heist/access-codes.txt
    sudo chown berlin:tech-team bank-heist/blueprints.pdf
    sudo chown nairobi:vault-team bank-heist/escape-plan.txt
### Verification
    ls -l bank-heist/
### Output
Permissions    owner      group
-rw-r--r--  1  tokyo    vault-team 0 Feb 11 11:00 access-codes.txt
-rw-r--r--  1  berlin   tech-team  0 Feb 11 11:00 blueprints.pdf
-rw-r--r--  1  nairobi  vault-team 0 Feb 11 11:00 escape-plan.txt
### What I Learned
1. File ownership directly impacts access and security
2. chown can modify both owner and group in one command
3. Recursive ownership is essential for real-world deployments

