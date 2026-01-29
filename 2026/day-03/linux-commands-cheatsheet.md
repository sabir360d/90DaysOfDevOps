# Linux Commands Cheat Sheet

## 1. Process Management
- ps aux = list all running processes
- top = live CPU and memory usage
- htop = interactive process viewer (if installed)
- kill <PID> = terminate a process
- uptime = system load and uptime

## 2. File System & Logs
- pwd = show current directory
- ls -l = list files with details
- cd <dir> = change directory
- df -h = disk usage summary
- wc <file> = count lines, words, and characters in a file

## 3. Networking
- ping <host> = test connectivity
- ip -a = show all interfaces and IP addresses
- curl <url> = test HTTP endpoints
- traceroute <host> = trace packet route to host
- ss -tuln = list listening ports

## 4. Services
- systemctl status <service> = check service health
- systemctl start <service> = start service
- systemctl stop <service> = stop service
- systemctl is-active <service> = check if service is running
- systemctl enable --now <service> = enable and start service immediately

