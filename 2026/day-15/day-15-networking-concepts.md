# Day 15 – Networking Concepts: DNS, IP, Subnets & Ports

## Objective

Understand the basic networking concepts used by DevOps engineers, including DNS, IP addressing, CIDR, subnetting, and ports.

---

# Task 1 – DNS: How Names Become IPs

## What happens when you type `google.com` in a browser?

When I type `google.com` in a browser, the browser needs to find the IP address associated with the domain name.

The DNS resolver looks up the domain and returns its IP address.

The browser then uses that IP address to connect to the Google server and request the webpage.

This allows users to use easy-to-remember domain names instead of IP addresses.

---

## DNS Record Types

| Record | Purpose |
|--------|---------|
| **A** | Maps a domain name to an IPv4 address. |
| **AAAA** | Maps a domain name to an IPv6 address. |
| **CNAME** | Creates an alias that points one domain name to another. |
| **MX** | Specifies the mail servers responsible for receiving email for a domain. |
| **NS** | Specifies the authoritative name servers for a domain. |

---

## Check DNS Resolution

### Command

```bash
dig google.com
```

### Output

```text
; <<>> DiG 9.10.6 <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16267
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		87	IN	A	142.250.29.100
google.com.		87	IN	A	142.250.29.101
google.com.		87	IN	A	142.250.29.138
google.com.		87	IN	A	142.250.29.113
google.com.		87	IN	A	142.250.29.139
google.com.		87	IN	A	142.250.29.102

;; Query time: 16 msec
;; SERVER: 2401:4900:50:9::7dd#53(2401:4900:50:9::7dd)
;; WHEN: Tue Aug 11 15:31:16 IST 2026
;; MSG SIZE  rcvd: 135
```

### A Record

```text
- 142.250.29.100
- 142.250.29.101
- 142.250.29.138
- 142.250.29.113
- 142.250.29.139
- 142.250.29.102
```

### TTL

```text
The number 87 located directly between the domain name and IN A is the TTL value in seconds.
```

### Observation

The `dig` command provided DNS information for `google.com`. I identified the IPv4 address from the A record and checked its TTL value.

---

# Task 2 – IP Addressing

## What is an IPv4 Address?

An IPv4 address is a 32-bit address used to identify a device or network interface.

It is divided into four 8-bit sections called octets and is written in decimal format.

Example:

```text
192.168.1.10
```

The four octets are:

```text
192 . 168 . 1 . 10
```

Each octet can have a value from `0` to `255`.

---

## Public vs Private IP

### Private IP

A private IP is used inside a local/private network and is not directly routable over the public internet.

Example:

```text
192.168.1.10
```

### Public IP

A public IP is used to communicate with systems over the internet.

Example:

```text
8.8.8.8
```

---

## Private IP Ranges

| Private Range | CIDR |
|---------------|------|
| `10.0.0.0 – 10.255.255.255` | `10.0.0.0/8` |
| `172.16.0.0 – 172.31.255.255` | `172.16.0.0/12` |
| `192.168.0.0 – 192.168.255.255` | `192.168.0.0/16` |

---

## Check My IP Addresses

### Command

```bash
ip addr show
```

### Output

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 06:1d:f6:58:96:31 brd ff:ff:ff:ff:ff:ff
    altname enp0s5
    altname enx061df6589631
    inet 172.31.42.70/20 metric 100 brd 172.31.47.255 scope global dynamic ens5
       valid_lft 3090sec preferred_lft 3090sec
    inet6 fe80::41d:f6ff:fe58:9631/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever
```

### Private IP Address Identified

```text
172.31.42.70
```

### Observation

I used `ip addr show` to identify the IP addresses assigned to my network interfaces. The address in the private IP ranges was identified as my private IP.

---

# Task 3 – CIDR & Subnetting

## What does `/24` mean?

In:

```text
192.168.1.0/24
```

`/24` means that the first 24 bits are used for the network portion of the address.

The remaining 8 bits are available for host addresses.

The subnet mask for `/24` is:

```text
255.255.255.0
```

---

## Usable Hosts

### `/24`

```text
Total IPs = 256
Usable Hosts = 254
```

### `/16`

```text
Total IPs = 65,536
Usable Hosts = 65,534
```

### `/28`

```text
Total IPs = 16
Usable Hosts = 14
```

For traditional IPv4 subnets, the network address and broadcast address are not assigned to normal hosts.

---

## Why Do We Subnet?

Subnetting divides a larger network into smaller networks.

It helps organize IP addresses, reduce unnecessary network traffic, separate different systems or environments, and make network management easier.

---

## CIDR Table

| CIDR | Subnet Mask | Total IPs | Usable Hosts |
|------|-------------|----------:|-------------:|
| `/24` | `255.255.255.0` | 256 | 254 |
| `/16` | `255.255.0.0` | 65,536 | 65,534 |
| `/28` | `255.255.255.240` | 16 | 14 |

---

# Task 4 – Ports: The Doors to Services

## What is a Port?

A port is a logical number used to identify a particular service or application running on a device.

An IP address identifies the machine, while the port identifies the service running on that machine.

For example:

```text
192.168.1.10:22
```

Here:

```text
IP Address = 192.168.1.10
Port       = 22
```

Port `22` is normally used by SSH.

---

## Common Ports

| Port | Service |
|-----:|---------|
| `22` | SSH |
| `80` | HTTP |
| `443` | HTTPS |
| `53` | DNS |
| `3306` | MySQL |
| `6379` | Redis |
| `27017` | MongoDB |

---

## Check Listening Ports

### Command

```bash
ss -tulpn
```

### Output

```text
Netid       State        Recv-Q       Send-Q                 Local Address:Port               Peer Address:Port       Process
udp         UNCONN       0            0                          127.0.0.1:323                     0.0.0.0:*
udp         UNCONN       0            0                         127.0.0.54:53                      0.0.0.0:*
udp         UNCONN       0            0                      127.0.0.53%lo:53                      0.0.0.0:*
udp         UNCONN       0            0                  172.31.42.70%ens5:68                      0.0.0.0:*
udp         UNCONN       0            0                              [::1]:323                        [::]:*
tcp         LISTEN       0            4096                      127.0.0.54:53                      0.0.0.0:*
tcp         LISTEN       0            4096                   127.0.0.53%lo:53                      0.0.0.0:*
tcp         LISTEN       0            4096                         0.0.0.0:22                      0.0.0.0:*
tcp         LISTEN       0            4096                            [::]:22                         [::]:*
```

---

## Listening Port 1

```text
Port: 22
Service: ssh
```

## Listening Port 2

```text
Port: 53
Service: domain
```

### Observation

The `ss -tulpn` command displayed the TCP and UDP ports currently listening on my system. I identified at least two listening ports and matched them with their services.

---

# Task 5 – Putting It Together

## Scenario 1

### Command

```bash
curl http://myapp.com:8080
```

### Answer

Several networking concepts are involved here. DNS may resolve `myapp.com` to an IP address, and the connection uses IP networking and TCP.

Port `8080` identifies the application service, while HTTP is used at the application layer.

---

## Scenario 2

### Problem

My application cannot reach:

```text
10.0.1.50:3306
```

### What would I check first?

First, I would check whether the server is reachable:

```bash
ping 10.0.1.50
```

Then I would check whether port `3306` is reachable:

```bash
nc -zv 10.0.1.50 3306
```

If the port is not reachable, I would check the MySQL service, firewall/security-group rules, network routes, and whether MySQL is listening on port `3306`.

---

# What I Learned

1. **DNS** allows users to access services using domain names instead of remembering IP addresses.

2. **CIDR and subnetting** help divide networks into smaller and more manageable networks.

3. **Ports** identify individual services running on a host, allowing multiple services to use the same IP address.

---

# Commands Practiced

```bash
dig google.com

ip addr show

ss -tulpn

ping 10.0.1.50

nc -zv 10.0.1.50 3306
```

---

# Key Networking Flow

```text
Domain Name
     ↓
    DNS
     ↓
 IP Address
     ↓
    Port
     ↓
 TCP / UDP
     ↓
 Application
```

### Example

```text
http://myapp.com:8080
          ↓
         DNS
          ↓
     IP Address
          ↓
         TCP
          ↓
      Port 8080
          ↓
         HTTP
```

---

# Conclusion

Day 15 helped me understand how DNS, IP addresses, subnets, and ports work together when applications communicate over a network.

These concepts are important for troubleshooting connectivity problems in Linux, cloud environments, and DevOps infrastructure.
