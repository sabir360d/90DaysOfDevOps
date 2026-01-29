**Linux Architecture, Processes, and systemd**

**1. Core Components of Linux**
**Kernel**
- The **core of the operating system**
- Directly interacts with hardware:
  - CPU
  - Memory (RAM)
  - Disk
  - Devices
- Responsible for:
  - Process management
  - Memory management
  - Hardware communication

**User Space**
- Where users and applications run
- Includes:
  - Shell (bash, zsh)
  - System utilities
  - Applications (nginx, docker, ssh)
- Users interact with the kernel **through the shell**

**init / systemd**
- The **first process started by the kernel**
- Always has **PID 1**
- Starts and manages system services during boot

**2. Linux Boot Process**
1. Power ON
2. BIOS initializes hardware
3. GRUB loads the kernel
4. Linux Kernel starts
5. systemd (PID 1) starts
6. Services start (ssh, docker, nginx)

**3. Processes in Linux**
- Every running program is a **process**
- Each process has a **Process ID (PID)**

**Common Process States**
- **Running (R)** – currently executing
- **Sleeping (S)** – waiting for input or resource
- **Zombie (Z)** – finished but not cleaned up by parent

**4. How Linux Manages Processes**
- Kernel schedules processes using CPU time slices
- Parent processes create child processes
- systemd manages long-running background services
- Failed services can be automatically restarted

**5. systemd and Why It Matters**
- Controls:
  - Service startup
  - Service monitoring
  - Service restarts
- Makes systems:
  - More reliable
  - Easier to debug
- Central tool for managing production servers

**Useful systemd Commands**
systemctl start <service>
systemctl stop <service>
systemctl status <service>
systemctl restart <service>
systemctl enable <service>

**6. Daily Linux Commands (DevOps Use)**

1. ps – view running processes
2. top – monitor CPU and memory usage
3. systemctl – manage services
4. df -h – check disk usage
5. free -h – check memory usage

**7. Why This Matters for DevOps**

- Linux is the base of most production systems
- Understanding processes helps:
  - Debug crashes
  - Fix performance issues
  - Analyze logs
- systemd knowledge saves time during incidents
