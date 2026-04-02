# Day 09 Challenge – Linux User & Group Management
### Task
Today's goal is to **practice user and group management** by completing hands-on challenges.
Figure out how to:
- Create users and set passwords
- Create groups and assign users
- Set up shared directories with group permissions

### Users & Groups Created
### Users
- tokyo
- berlin
- professor
- nairobi

### Groups
- developers
- admins
- project-team

### Group Assignments
-  User        Groups
-  tokyo       developers, project-team 
-  berlin      developers, admins       
-  professor   admins                   
-  nairobi     project-team             

### Directories Created
   Directory             Group Owner    Permissions 
-  /opt/dev-project      developers       775
-  /opt/team-workspace   project-team     775        

### Commands Used
### Task 1: Create Users
-   Create three users with home directories and passwords:
-   tokyo
-   berlin
-   professor
**Verify:** Check `/etc/passwd` and `/home/` directory
```bash
sudo useradd -m tokyo
sudo passwd tokyo
sudo useradd -m berlin
sudo passwd berlin
sudo useradd -m professor
sudo passwd professor
```
### Verify users
cat /etc/passwd
ls /home/
![image-path](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-09/task1a.JPG)
![[image alt](image-path)](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-09/task1b.JPG)

### Task 2: Create Groups
Create two groups:
- `developers`
- `admins`
**Verify:** Check `/etc/group`
```bash
sudo groupadd developers
sudo groupadd admins
```
### Verify groups
cat /etc/group
![image alt](https://github.com/sabir360d/90DaysOfDevOps/blob/master/2026/day-09/task2.JPG)
### Task 3: Assign Users to Groups
Assign users:
- `tokyo` => `developers`
- `berlin` => `developers` + `admins` (both groups)
- `professor` => `admins`
**Verify:** Use appropriate command to check group membership
```bash
sudo usermod -aG developers tokyo
sudo usermod -aG developers,admins berlin
sudo usermod -aG admins professor
```
### Verify memberships
groups tokyo
groups berlin
groups professor
![image alt]([image-path](https://github.com/sabir360d/90DaysOfDevOps/blob/88d21d1b5e544743a9a75f13f90ee39043dc23bd/2026/day-09/task3.JPG))

### Task 4: Shared Directory
1. Create directory: `/opt/dev-project`
2. Set group owner to `developers`
3. Set permissions to `775` (rwxrwxr-x)
4. Test by creating files as `tokyo` and `berlin`
**Verify:** Check permissions and test file creation
```bash
sudo mkdir /opt/dev-project
sudo chgrp developers /opt/dev-project
sudo chmod 775 /opt/dev-project
```
### Test file creation
sudo -u tokyo touch /opt/dev-project/tokyo_file.txt
sudo -u berlin touch /opt/dev-project/berlin_file.txt
### Verify permissions
ls -ld /opt/dev-project
ls -l /opt/dev-project
![image alt]([image-path](https://github.com/sabir360d/90DaysOfDevOps/blob/88d21d1b5e544743a9a75f13f90ee39043dc23bd/2026/day-09/task4.JPG))

### Task 5: Team Workspace
1. Create user `nairobi` with home directory
2. Create group `project-team`
3. Add `nairobi` and `tokyo` to `project-team`
4. Create `/opt/team-workspace` directory
5. Set group to `project-team`, permissions to `775`
6. Test by creating file as `nairobi`
### Hints
**Try these commands:**
- User: `useradd`, `passwd`, `usermod`
- Group: `groupadd`, `groups`
- Permissions: `chgrp`, `chmod`
- Test: `sudo -u username command`
**Tip:** Use `-m` flag with useradd for home directory, `-aG` for adding to groups
```bash
sudo useradd -m nairobi
sudo passwd nairobi
sudo groupadd project-team
sudo usermod -aG project-team tokyo
sudo usermod -aG project-team nairobi
sudo mkdir /opt/team-workspace
sudo chgrp project-team /opt/team-workspace
sudo chmod 775 /opt/team-workspace
```
### Test file creation
sudo -u nairobi touch /opt/team-workspace/nairobi_file.txt
### Verify permissions
ls -ld /opt/team-workspace
ls -l /opt/team-workspace
![image alt](https://github.com/sabir360d/90DaysOfDevOps/blob/88d21d1b5e544743a9a75f13f90ee39043dc23bd/2026/day-09/task5.JPG)

### What I Learned
- Users can belong to multiple groups, and permissions follow the group ownership of directories.
- Shared directories require correct group ownership and proper permission bits (like 775) for collaboration.
- Testing commands as other users (sudo -u username command) is essential to ensure access rights are configured correctly.
