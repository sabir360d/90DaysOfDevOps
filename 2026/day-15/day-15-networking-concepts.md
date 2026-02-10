# Day 15 – Networking Concepts: DNS, IP, Subnets & Ports

## Task
Build on Day 14 by understanding the building blocks of networking every DevOps engineer must know.

* Understand how DNS resolves names to IPs
* Learn IP addressing (IPv4, public vs private)
* Break down CIDR notation and subnetting basics
* Know common ports and why they matter

---

## Task 1: DNS - How Names Become IPs

### 1. What happens when you type `google.com` in a browser?
1. When `google.com` is entered into a browser, the system first checks the local DNS cache. 
2. If no record exists, it queries a DNS resolver, which then communicates with root, TLD, and authoritative DNS servers. 
3. The authoritative server responds with the IP address, allowing the browser to establish a connection to the server.

### 2. DNS Record Types
- **A** – Maps a domain name to an IPv4 address  
- **AAAA** – Maps a domain name to an IPv6 address  
- **CNAME** – Creates an alias pointing one domain to another  
- **MX** – Specifies mail servers responsible for receiving emails  
- **NS** – Identifies authoritative name servers for a domain  

### 3. `dig google.com`
Command executed:
```bash
dig google.com
```
![dig google.com](https://github.com/sabir360d/90DaysOfDevOps/blob/d91153eaa1f48b250c060c423cd37d8ffdb03c77/2026/day-15/screenshots/dig_google.JPG)

Let's identify the **A record** and **TTL** from the above output:
- A: A record type (IPv4 address). In our case we have six A records (142.251.16.101 ... 142.251.16.139).
- TTL: Time To Live = 49 seconds (applies to all six A records in this response)

---

## Task 2: IP Addressing

### 1. What is an IPv4 address? How is it structured? (e.g., 192.168.1.10)
An IPv4 address is a 32-bit numerical identifier assigned to a device on a network. It is written as four octets separated by dots, for example: `192.168.1.10`

---

### 2. Public vs Private IPs
- **Public IP:** Routable over the internet and globally unique, (example: `142.251.16.101` used by Google globally for services like google.com)  
- **Private IP:** Used within internal networks and not routable on the internet (example: `192.168.1.10`)  

---

### 3. Private IP Ranges
- `10.0.0.0 – 10.255.255.255`  
- `172.16.0.0 – 172.31.255.255`  
- `192.168.0.0 – 192.168.255.255`  

---

### 4.Run: `ip addr show` -  identify which of your IPs are private
Command executed:
```
bash
ip addr show
```
![ip addr show](https://github.com/sabir360d/90DaysOfDevOps/blob/d91153eaa1f48b250c060c423cd37d8ffdb03c77/2026/day-15/screenshots/ip%20addr%20show.JPG)
- `172.31.72.136` Indentified as the Private IP
- Why? Because 172.16.0.0 – 172.31.255.255 is a Private IP range
- Scope global here means “reachable within VPC or LAN”
- brd 172.31.79.255 → broadcast address for that subnet
---

## Task 3: CIDR & Subnetting

### 1. What does `/24` mean in `192.168.1.0/24`?
`/24` indicates that the first 24 bits of the IP address are reserved for the network portion, leaving 8 bits available for host addresses.

### 2. How many usable hosts in a /24?, a /16?, a /28?
Usable Hosts per Subnet
- **/24:** 254 usable hosts  
- **/16:** 65,534 usable hosts  
- **/28:** 14 usable hosts  

### 3. Why do we subnet?
Subnetting improves network organization, reduces broadcast traffic, enhances security boundaries, and enables efficient allocation of IP addresses.

---

### 4. CIDR Reference Table

| CIDR | Subnet Mask       | Total IPs | Usable Hosts |
|------|-------------------|-----------|--------------|
| /24  | 255.255.255.0     | 256       | 254          |
| /16  | 255.255.0.0       | 65,536    | 65,534       |
| /28  | 255.255.255.240   | 16        | 14           |

---

## Task 4: Ports – The Doors to Services

### 1. What is a port?
A port is a logical communication endpoint that allows a system to distinguish between different services running on the same IP address.

---

### 2. Commonly Used Ports

| Port | Service  |
|------|----------|
| 22   | SSH      |
| 80   | HTTP     |
| 443  | HTTPS    |
| 53   | DNS      |
| 3306 | MySQL    |
| 6379 | Redis    |
| 27017| MongoDB  |

---

### 3. Run `ss -tulpn` - match at least 2 listening ports to their services
Command executed:
```bash
ss -tulpn
```
![ss -tulpn](https://github.com/sabir360d/90DaysOfDevOps/blob/52d435403474888963c7bcb65e7395201e754215/2026/day-15/screenshots/ss%20-tulpn.JPG)
Observed listening services:
- Port `22` mapped to SSH server service (0.0.0.0:22) 
- Port `53` mapped to DNS resolver service (127.0.0.54:53)
---
## Task 5: Putting It Together
### `curl http://myapp.com:8080`
DNS resolves `myapp.com` to an IP address, TCP establishes the connection, HTTP is used as the protocol, and port `8080` directs traffic to the correct application service.
---
### Application cannot reach `10.0.1.50:3306`
Verify network connectivity, firewall or security group rules, ensure MySQL is listening on port `3306`, and confirm the private IP address is reachable.
---
## Learning Highlights
- DNS translates human-readable domain names into IP addresses  
- CIDR notation defines network and host boundaries  
- Subnetting improves scalability, security, and IP efficiency  
- Ports enable multiple services to coexist on a single machine  

---
