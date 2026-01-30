## Full Session Log
```text
Script started on 2026-01-30 03:06:01-06:00 [TERM="xterm" TTY="/dev/pts/1" COLUMNS="121" LINES="36"]
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# ls
[?2004l[0m[01;34mdevop2[0m  [01;34mdevops[0m  hello.txt  linux-practice.log  linux-practice.md
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# clear
[?2004l[H[2J[3J[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# ps -p $$
[?2004l    PID TTY          TIME CMD
   2880 pts/2    00:00:00 bash
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# ps [K[Kgrep -l ssh
[?2004l1005 sshd
1006 sshd
1120 sshd
1786 sshd
2869 sshd
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# systemctl status ssh
[?2004l[?1h=[0;1;32m●[0m ssh.service - OpenBSD Secure Shell server[m
     Loaded: loaded (]8;;file://ip-172-31-15-139/usr/lib/systemd/system/ssh.service/usr/lib/systemd/system/ssh.service]8;;; [0;1;32menabled[0m; preset: [0;1;32menabled[0m)[m
    Drop-In: /usr/lib/systemd/system/ssh.service.d[m
             └─]8;;file://ip-172-31-15-139/usr/lib/systemd/system/ssh.service.d/ec2-instance-connect.confec2-instance-connect.conf]8;;[m
     Active: [0;1;32mactive (running)[0m since Fri 2026-01-30 03:04:56 CST; 2min 4s ago[m
TriggeredBy: [0;1;32m●[0m ssh.socket[m
       Docs: ]8;;man:sshd(8)man:sshd(8)]8;;[m
             ]8;;man:sshd_config(5)man:sshd_config(5)]8;;[m
    Process: 2868 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)[m
   Main PID: 2869 (sshd)[m
      Tasks: 3 (limit: 1017)[m
     Memory: 7.5M (peak: 8.7M)[m
        CPU: 17ms[m
     CGroup: /system.slice/ssh.service[m
             ├─[0;38;5;245m1005 "sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized[m[7m>[27m
             ├─[0;38;5;245m1786 "sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized[m[7m>[27m
             └─[0;38;5;245m2869 "sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized[m[7m>[27m
[m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...[m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: Found left-over process 1005 (sshd) in control group while sta[m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: This usually indicates unclean termination of a previous run, [m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: Found left-over process 1786 (sshd) in control group while sta[m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: This usually indicates unclean termination of a previous run, [m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on 0.0.0.0 port 22.[m
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on :: port 22.[m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: Started ssh.service - OpenBSD Secure Shell server.[m
[7mlines 1-26/26 (END)[27m[K[K[?1l>[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# systemctl status ssh[C[C[C[C[K[K[Kapache2[K[K[K[K[K[K[K[K[K[K[K[K[K[Kis-enabled ssh
[?2004lenabled
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# journalctl -u shh [K[K[Ksh -n 5 --no-pager
[?2004lJan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: Found left-over process 1786 (sshd) in control group while starting unit. Ignoring.[0m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: This usually indicates unclean termination of a previous run, or service implementation deficiencies.[0m
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on 0.0.0.0 port 22.
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on :: port 22.
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# su[K[Ksudo tail -n 5 /var/log/syslog
[?2004l2026-01-30T03:04:56.973002-06:00 ip-172-31-15-139 systemd[1]: ssh.service: This usually indicates unclean termination of a previous run, or service implementation deficiencies.
2026-01-30T03:04:56.973056-06:00 ip-172-31-15-139 systemd[1]: ssh.service: Found left-over process 1786 (sshd) in control group while starting unit. Ignoring.
2026-01-30T03:04:56.973081-06:00 ip-172-31-15-139 systemd[1]: ssh.service: This usually indicates unclean termination of a previous run, or service implementation deficiencies.
2026-01-30T03:04:56.987019-06:00 ip-172-31-15-139 systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
2026-01-30T03:05:01.988286-06:00 ip-172-31-15-139 CRON[2873]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# #Tr[K[K Troubleshooting ssh
[?2004l[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# # Unable to ssh into server
[?2004l[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# systemctl status ssh
[?2004l[?1h=[0;1;32m●[0m ssh.service - OpenBSD Secure Shell server[m
     Loaded: loaded (]8;;file://ip-172-31-15-139/usr/lib/systemd/system/ssh.service/usr/lib/systemd/system/ssh.service]8;;; [0;1;32menabled[0m; preset: [0;1;32menabled[0m)[m
    Drop-In: /usr/lib/systemd/system/ssh.service.d[m
             └─]8;;file://ip-172-31-15-139/usr/lib/systemd/system/ssh.service.d/ec2-instance-connect.confec2-instance-connect.conf]8;;[m
     Active: [0;1;32mactive (running)[0m since Fri 2026-01-30 03:04:56 CST; 7min ago[m
TriggeredBy: [0;1;32m●[0m ssh.socket[m
       Docs: ]8;;man:sshd(8)man:sshd(8)]8;;[m
             ]8;;man:sshd_config(5)man:sshd_config(5)]8;;[m
    Process: 2868 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)[m
   Main PID: 2869 (sshd)[m
      Tasks: 3 (limit: 1017)[m
     Memory: 7.5M (peak: 8.7M)[m
        CPU: 17ms[m
     CGroup: /system.slice/ssh.service[m
             ├─[0;38;5;245m1005 "sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized[m[7m>[27m
             ├─[0;38;5;245m1786 "sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized[m[7m>[27m
             └─[0;38;5;245m2869 "sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized[m[7m>[27m
[m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...[m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: Found left-over process 1005 (sshd) in control group while sta[m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: This usually indicates unclean termination of a previous run, [m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: Found left-over process 1786 (sshd) in control group while sta[m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: This usually indicates unclean termination of a previous run, [m[7m>[27m
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on 0.0.0.0 port 22.[m
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on :: port 22.[m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: Started ssh.service - OpenBSD Secure Shell server.[m
[7mlines 1-26/26 (END)[27m[K[K[?1l>[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# sy[K[Kpgrep -l ssh
[?2004l1005 sshd
1006 sshd
1120 sshd
1786 sshd
2869 sshd
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# jourb[Knalcrtl[K[K[Ktl -u ssh -n 2[K5 --no-pager
[?2004lJan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: Found left-over process 1786 (sshd) in control group while starting unit. Ignoring.[0m
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: [0;1;38;5;185m[0;1;39m[0;1;38;5;185mssh.service: This usually indicates unclean termination of a previous run, or service implementation deficiencies.[0m
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on 0.0.0.0 port 22.
Jan 30 03:04:56 ip-172-31-15-139 sshd[2869]: Server listening on :: port 22.
Jan 30 03:04:56 ip-172-31-15-139 systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# # ssh service is running and responding.
[?2004l[?2004h]0;root@ip-172-31-15-139: /home/ubunturoot@ip-172-31-15-139:/home/ubuntu# exit
[?2004lexit

Script done on 2026-01-30 03:15:26-06:00 [COMMAND_EXIT_CODE="0"]
```
