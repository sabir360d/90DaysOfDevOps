# Day 10 Challenge – File Permissions & File Operations
### Task 1: Create Files
- Created empty file `devops.txt` using:
    touch devops.txt
- Created notes.txt with content:
    echo "These are my DevOps notes." > notes.txt
- Created script.sh using vim with content:
    vim script.sh
    echo "Hello DevOps"
- Verified files and initial permissions:
    ls -l
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/9d5fab3e1dc0eccb1197a79d807259e0d9e4d27b/2026/day-10/task1.JPG) 
### Task 2: Read Files
- Read notes.txt:
    cat notes.txt
- Opened script.sh in read-only vim:
    vim -R script.sh
- Displayed first 5 lines of /etc/passwd:
    head -n 5 /etc/passwd
- Displayed last 5 lines of /etc/passwd:
    tail -n 5 /etc/passwd
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-10/task2.JPG)
### Task 3: Understand Permissions
- Checked file permissions:
    ls -l devops.txt notes.txt script.sh
- Permissions format: rwxrwxrwx (owner-group-others)
    r = read (4)
    w = write (2)
    x = execute (1)
- Current permissions: 
1. devops.txt: rw-r--r-- → owner can read/write, group can read, others can read
2. notes.txt: rw-r--r-- → owner can read/write, group can read, others can read
3. script.sh: rw-r--r-- → owner can read/write, group can read, others can read
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-10/task3.JPG)
### Task 4: Modify Permissions
- Made script.sh executable:
    chmod +x script.sh
    ./script.sh
- Set devops.txt to read-only (removed write for all):
    chmod a-w devops.txt
- Set notes.txt to 640 (owner: rw, group: r, others: none):
    chmod 640 notes.txt
- Created directory project/ with permissions 755:
    mkdir project
    chmod 755 project
- Verified changes:
    ls -l
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-10/task4.JPG)
### Task 5: Test Permissions
- Tried writing to devops.txt (read-only):
    echo "Trying to write" >> devops.txt
**Error message: bash: devops.txt: Permission denied**
![image Alt](https://github.com/sabir360d/90DaysOfDevOps/blob/9d5fab3e1dc0eccb1197a79d807259e0d9e4d27b/2026/day-10/task5.JPG)  
- Tried executing notes.txt (no execute permission):
    ./notes.txt
**Error message: bash: ./notes.txt: Permission denied**
### Files Created
    devops.txt
    notes.txt
    script.sh
    Directory: project/
### Permission Changes
    devops.txt: read-only for all
    notes.txt: 640
    script.sh: executable added
    project/: 755
### Commands Used
    touch devops.txt
    echo "These are my DevOps notes." > notes.txt
    vim script.sh
    ls -l
    cat notes.txt
    vim -R script.sh
    head -n 5 /etc/passwd
    tail -n 5 /etc/passwd
    chmod +x script.sh
    ./script.sh
    chmod a-w devops.txt
    chmod 640 notes.txt
    mkdir project
    chmod 755 project
## What I Learned
1. File permissions control who can read, write, or execute files and directories.
2. chmod is powerful for setting permissions using symbolic (+x) or numeric (640) methods.
3. Trying to write to read-only files or execute non-executable files results in clear permission errors, reinforcing proper access control.
