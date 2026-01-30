# Day 04 – Linux Practice: Processes and Services

---

## Process Checks

**`ps -p $$`**

**`pgrep -l ssh`**

```text
root@ip-172-31-15-139:/home/ubuntu# ps -p $$
    PID TTY          TIME CMD
   2880 pts/2    00:00:00 bash
root@ip-172-31-15-139:/home/ubuntu# pgrep -l ssh
1005 sshd
1006 sshd
1120 sshd
1786 sshd
2869 sshd
```

## Service Checks

**`systemctl status ssh`**

**`systemctl is-enabled ssh`**

```text
root@ip-172-31-15-139:/home/ubuntu# systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-01-30 03:04:56 CST; 2min 4s ago

root@ip-172-31-15-139:/home/ubuntu# systemctl is-enabled ssh
enabled

```

## Log Checks

**`journalctl -u ssh -n 5 --no-pager`**

**`sudo tail -n 5 /var/log/syslog`**

```text
root@ip-172-31-15-139:/home/ubuntu# journalctl -u ssh -n 2 --no-pager
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: ssh.service: Found left-over process 1786 (sshd)
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: ssh.service: This usually indicates termination..

root@ip-172-31-15-139:/home/ubuntu# sudo tail -n 2 /var/log/syslog
2026-01-30T03:04:56.973002-06:00 ip-172-31-15-139 systemd[1]: ssh.service: This usually indicates unclean termination of a previous run, or service implementation deficiencies.
2026-01-30T03:04:56.973056-06:00 ip-172-31-15-139 systemd[1]: ssh.service: Found left-over process 1786 (sshd) in control group while starting unit. Ignoring.

```

## Inspect one systemd service

## Unable to ssh into server

```text
root@ip-172-31-15-139:/home/ubuntu# systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-01-30 03:04:56 CST; 7min ago
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on 0.0.0.0 port 22.
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on :: port 22.

root@ip-172-31-15-139:/home/ubuntu# pgrep -l ssh
1005 sshd
1006 sshd

root@ip-172-31-15-139:/home/ubuntu# journalctl -u ssh -n 2 --no-pager
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: ssh.service: Found left-over process 1786 (sshd) in control group while starting unit. Ignoring.
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: ssh.service: This usually indicates unclean termination of a previous run, or service implementation deficiencies.

## ssh service is running and responding. Issues fixed.

```

