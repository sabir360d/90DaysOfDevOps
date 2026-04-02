
# Linux Troubleshooting Runbook

## Target Service

**apache2 (Apache Web Server)** on Ubuntu

---

## Environment Basics

```bash
uname -a
```

*Observation:* Ubuntu Linux kernel running on x86_64. No kernal errors observed.

```bash
lsb_release -a
```

*Observation:* System is running Ubuntu 22.04 Server LTS.

---

## Filesystem Sanity Check

```bash
mkdir /tmp/runbook-demo
cp /etc/hosts /tmp/runbook-demo/hosts-copy
ls -l /tmp/runbook-demo
```

*Observation:* Directory created successfully and is writable. File successfully copied without errors indicating normal disk behavior. Checked file permissions and ownership which looked normal with no access isues detected.

---

## Snapshot: CPU & Memory

```bash
ps -o pid,pcpu,pmem,comm -C apache2
```

*Observation:* Multiple apache2 worker processes running with low CPU (<1%) and memory usage.

```bash
free -h
```

*Observation:* Sufficient free memory. No swap usage.

---

## Snapshot: Disk & IO

```bash
df -h
```

*Observation:* Root filesystem has adequate free space. 

```bash
du -sh /var/log/apache2
```

*Observation:* Apache2 logs are small. No excessive growth.

---

## Snapshot: Network

```bash
ss -tulpn | grep apache2
```

*Observation:* Apache2 listening on port 80.

```bash
curl -I http://localhost
```

*Observation:* HTTP 200 OK response returned. Apache2 is serving requests correctly.

---

## Logs Reviewed

```bash
journalctl -u apache2 -n 50
```

*Observation:* No recent service errors. Logs show normal service startup and operation.

```bash
tail -n 50 /var/log/apache2/error.log
```

*Observation:* No critical errors in recent Apache2 logs.

---

## Quick Findings

* Apache2 service is healthy and responsive.
* Resource usage is low, disk and network are stable.
* Logs show no signs of errors or misconfiguration.

---

## If This Worsens (Next Steps)

1. Restart Apache safely: `systemctl restart apache2`
2. Increase log verbosity and monitor error logs
3. Capture deeper diagnostics (e.g., `apachectl status`, `strace` on worker PID)

