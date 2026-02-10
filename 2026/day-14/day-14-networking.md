# Day 14 – Networking Fundamentals & Hands-on Checks

## Goal
Understand core networking concepts and practice real troubleshooting commands using a real-world service: **github.com**.

---

## Quick Concepts

### OSI (L1–L7) vs TCP/IP
- **OSI model** is conceptual and helps isolate where a network issue occurs.
- **TCP/IP model** is the practical stack used in modern systems.

| OSI Layer | TCP/IP Layer | Examples        |
|-----------|--------------|-----------------|
| L7–L5     | Application  | HTTP, HTTPS, DNS |
| L4        | Transport    | TCP, UDP       |
| L3        | Internet     | IP, ICMP       |
| L2–L1     | Link         | Ethernet, Wi-Fi |
  

---
### Protocol Placement
| Protocol       | OSI Layer                     |
|----------------|-------------------------------|
| IP             | Internet layer (OSI L3)       |
| TCP / UDP      | Transport layer (OSI L4)      |
| HTTP / HTTPS   | Application layer (OSI L7)    |
| DNS            | Application layer (relies on UDP/TCP) |

---
### Real Example
- `curl https://github.com`  
  => Application layer (HTTPS) running over **TCP**, routed via **IP**
---
## Hands-on Checklist
**Target host:** `github.com`
### Identity
```bash
hostname -I
```
![Screenshot description](path/to/screenshot.png)

**Observation:** Displays the system’s assigned IP address.

### Reachability
```bash
ping github.com
```
![Screenshot description](path/to/screenshot.png)
**Observation:** ICMP replies received with low latency and no packet loss.

### Network Path
```bash
traceroute github.com
```
![Screenshot description](path/to/screenshot.png)

**Observation:** Traffic traverses multiple hops through ISP and backbone networks. Some hops may not respond due to ICMP filtering.

### Listening Ports
```bash
ss -tulpn
```
![Screenshot description](path/to/screenshot.png)
**Observation:** 
This output shows **which services are listening on my system, on which ports, and exactly which processes own them**, which is crucial for security and troubleshooting.
* **DNS (port 53)**: `systemd-resolve` is listening on localhost only (`127.0.0.53/54`), meaning DNS is not exposed to the network—good for security.
* **SSH (port 22)**: `sshd` is listening on all IPv4 and IPv6 interfaces (`0.0.0.0` and `::`), so the machine is reachable for remote logins.
* **Time sync (port 323)**: `chronyd` handles NTP locally, normal system behavior.
* **DHCP (port 68)**: `systemd-networkd` is handling IP address assignment on the network interface.

Overall, this confirms **only essential services are exposed**, and `ss` clearly maps each open port to the responsible process and PID.

### DNS Resolution
```bash
dig github.com
```
![Screenshot description](path/to/screenshot.png)

**Observation:** This `dig` output shows that a DNS query successfully resolved github.com to the IPv4 address 140.82.113.4 in 1 ms using the local DNS resolver.

### HTTP / HTTPS Check
```bash
curl -I https://github.com
```
![Screenshot description](path/to/screenshot.png)

**Observation:** HTTP 200 OK received, confirming application-level connectivity.

### Active Connections Snapshot
```bash
netstat -an | head
```
![Screenshot description](path/to/screenshot.png)

**Observation:** System shows a combination of LISTEN and ESTABLISHED connections. Here `netstat -an | head` output shows which network ports my system is listening on and which connections are active, including local DNS services on port 53 and SSH on port 22. It also shows two active SSH connections to my machine from the remote IP `73.232.165.94`.

## Mini Task – Port Probe & Interpretation
### Identified Listening Service

- Service: SSH
- Port: 22

### Test Local Connectivity
```bash
nc -zv localhost 22
```
![Screenshot description](path/to/screenshot.png)

**Result:** Port is reachable.

### Reflection

- Fastest signal during an outage: ping (basic reachability).
- If DNS resolution fails: Inspect Application layer (DNS) first.
- If HTTP returns 500 errors: Investigate Application layer services and logs.

### Follow-up Checks in a Real Incident

- Review firewall rules (ufw status or iptables -L)
- Inspect service logs (journalctl -u ssh or application logs)
