# Day 13 – Linux Volume Management (LVM)

## Task
Learn how to manage Linux storage flexibly using **LVM (Logical Volume Manager)** by creating, mounting, and extending logical volumes without downtime.

---

## Environment
- OS: Ubuntu (EC2)
- User: root (`sudo su`)
- Disks used: `/dev/nvme1n1 `
---

## Task 1: Check Current Storage

### Commands
```bash
lsblk       # displays available disks and partitions
df -h       # displays filesystem usage
pvs         # display information about physical volumes
vgs         # display information about volume groups
lvs         # display information about logical volumes
```
### Purpose:
- Identify available disks
- Confirm no existing LVM metadata
- Understand current filesystem usage

![Initial storage state](images/your-screenshot.jpeg)

## Task 2: Create Physical Volume (PV)
### Command
```bash
pvcreate /dev/nvme1n1
```
### Verify
```bash
pvs
```
### Purpose
- Initialize raw disk for LVM usage
- `/dev/nvme1n1` initialized as a physical volume

![Physical Volume created](images/your-screenshot.jpeg)

## Task 3: Create Volume Group (VG)
### Command
```bash
vgcreate devops-vg /dev/nvme1n1 
```
### Verify
```bash
vgs
```
### Purpose
- Create volume group `devops-vg` successfully
- Pool storage into a logical group for flexible allocation

![Volume group details](images/your-screenshot.jpeg)

### Task 4: Create Logical Volume (LV)
### Command
```bash
lvcreate -L 500M -n app-data devops-vg
```
### Verify
```bash
lvs
```
### Purpose
- Create logical volume `app-data` with size 500MB
- Create application storage without tying it directly to disk size

![Logical volume created](images/your-screenshot.jpeg)

## Task 5: Format and Mount Logical Volume
### Commands
```bash
mkfs.ext4 /dev/devops-vg/app-data # Formats Volume/Creates filesystem structure (ext4)
mkdir -p /mnt/app-data # Creates Mount Point (/mnt/app-data) to access the volume (/dev/devops-vg/app-data)
mount /dev/devops-vg/app-data /mnt/app-data # Attach Volume or device (/dev/devops-vg/app-data) to the Mount Point (/mnt/app-data /mnt/app-data)
df -h /mnt/app-data # Check Status/Verify size and usage
```
### Purpose
- Format logical volume with `ext4`
- Mount successfully at `/mnt/app-data`

![Mounted FS](images/your-screenshot.jpeg)

## Task 6: Extend the Logical Volume
### Commands
```bash
lvextend -L +200M /dev/devops-vg/app-data
resize2fs /dev/devops-vg/app-data
df -h /mnt/app-data
```
### Purpose
- Extend logical volume from 500MB → 700MB without unmounting
- Filesystem resized without unmounting

![Extended volume size](images/your-screenshot.jpeg)

### What I Learned
- LVM allows dynamic resizing of storage without service downtime
- Logical volumes abstract physical disks, making storage management flexible and scalable.
- Extending a filesystem safely requires resizing both the logical volume and the filesystem.

### Insight
LVM is essential for real-world DevOps and production environments where storage needs change frequently and downtime is not an option.

---

