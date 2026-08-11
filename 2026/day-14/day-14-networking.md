# Day 14 – Networking Fundamentals & Hands-on Checks

## Objective

Practice basic networking commands and understand how the OSI and TCP/IP models relate to real network troubleshooting.

---

# Part 1 – Networking Concepts

## OSI Model vs TCP/IP Model

### OSI Model

| Layer | Name | Purpose |
|------:|------|---------|
| 7 | Application | Provides network services to applications |
| 6 | Presentation | Handles data formatting, encryption, and compression |
| 5 | Session | Establishes and manages communication sessions |
| 4 | Transport | Provides TCP/UDP communication |
| 3 | Network | Handles IP addressing and routing |
| 2 | Data Link | Handles MAC addresses and frames |
| 1 | Physical | Handles physical transmission of bits |

### TCP/IP Model

| TCP/IP Layer | Examples |
|--------------|----------|
| Application | HTTP, HTTPS, DNS, SSH |
| Transport | TCP, UDP |
| Internet | IP, ICMP |
| Link | Ethernet, Wi-Fi |

### In my own words

The OSI model has seven layers and is mainly used as a conceptual model for understanding networking.

The TCP/IP model has fewer layers and represents how networking is actually implemented on modern systems.

---

# Where Protocols Fit

- **IP** → Network/Internet layer
- **TCP/UDP** → Transport layer
- **HTTP/HTTPS** → Application layer
- **DNS** → Application layer

### Real Example

```text
curl https://example.com
        ↓
HTTPS
        ↓
TCP
        ↓
IP
        ↓
Network Interface
```

`curl https://example.com` is an application-layer request that uses TCP/IP underneath it.

---

# Part 2 – Hands-on Network Checks

## Target Host

For this practice I used:

```text
google.com
```

---

## 1. Identity – Check IP Address

### Command

```bash
hostname -I
```

### Output

```text
172.31.42.70
```

### Observation

The command displayed the IP address assigned to my system.

---

# 2. Reachability – Ping

### Command

```bash
ping google.com
```

### Output

```text
PING google.com (142.251.34.206) 56(84) bytes of data.
64 bytes from qro02s27-in-f14.1e100.net (142.251.34.206): icmp_seq=1 ttl=117 time=7.43 ms
64 bytes from qro02s27-in-f14.1e100.net (142.251.34.206): icmp_seq=2 ttl=117 time=7.46 ms
64 bytes from qro02s27-in-f14.1e100.net (142.251.34.206): icmp_seq=3 ttl=113 time=7.47 ms
```

### Observation

The target was reachable with approximately `2003 ms` latency and `0%` packet loss.

---

# 3. Path – Traceroute

### Command

```bash
traceroute google.com
```

### Output

```text
traceroute to google.com (142.251.34.206), 30 hops max, 60 byte packets
 1  * ec2-34-221-151-153.us-west-2.compute.amazonaws.com (34.221.151.153)  5.111 ms ec2-34-221-151-167.us-west-2.compute.amazonaws.com (34.221.151.167)  1.578 ms
 2  240.0.208.4 (240.0.208.4)  0.454 ms 240.0.208.5 (240.0.208.5)  0.438 ms  0.416 ms
 3  242.2.102.71 (242.2.102.71)  1.318 ms 100.66.24.100 (100.66.24.100)  16.021 ms 100.66.24.164 (100.66.24.164)  16.004 ms
 4  240.4.12.13 (240.4.12.13)  8.104 ms 100.66.22.216 (100.66.22.216)  7.181 ms 100.66.26.170 (100.66.26.170)  20.753 ms
 5  242.16.82.235 (242.16.82.235)  5.963 ms 241.0.1.131 (241.0.1.131)  0.646 ms 241.0.1.134 (241.0.1.134)  0.286 ms
 6  108.166.240.12 (108.166.240.12)  0.311 ms 240.1.228.3 (240.1.228.3)  6.897 ms 108.166.232.33 (108.166.232.33)  0.331 ms
 7  * * *
 8  242.11.42.135 (242.11.42.135)  8.780 ms * 240.4.12.14 (240.4.12.14)  8.941 ms
 9  242.11.43.133 (242.11.43.133)  7.046 ms 242.11.43.3 (242.11.43.3)  8.611 ms 242.11.43.5 (242.11.43.5)  9.342 ms
10  142.251.250.56 (142.251.250.56)  7.545 ms 216.239.56.223 (216.239.56.223)  6.920 ms qro02s27-in-f14.1e100.net (142.251.34.206)  6.024 mstraceroute to google.com (142.251.34.206), 30 hops max, 60 byte packets
 1  * ec2-34-221-151-153.us-west-2.compute.amazonaws.com (34.221.151.153)  5.111 ms ec2-34-221-151-167.us-west-2.compute.amazonaws.com (34.221.151.167)  1.578 ms
 2  240.0.208.4 (240.0.208.4)  0.454 ms 240.0.208.5 (240.0.208.5)  0.438 ms  0.416 ms
 3  242.2.102.71 (242.2.102.71)  1.318 ms 100.66.24.100 (100.66.24.100)  16.021 ms 100.66.24.164 (100.66.24.164)  16.004 ms
 4  240.4.12.13 (240.4.12.13)  8.104 ms 100.66.22.216 (100.66.22.216)  7.181 ms 100.66.26.170 (100.66.26.170)  20.753 ms
 5  242.16.82.235 (242.16.82.235)  5.963 ms 241.0.1.131 (241.0.1.131)  0.646 ms 241.0.1.134 (241.0.1.134)  0.286 ms
 6  108.166.240.12 (108.166.240.12)  0.311 ms 240.1.228.3 (240.1.228.3)  6.897 ms 108.166.232.33 (108.166.232.33)  0.331 ms
 7  * * *
 8  242.11.42.135 (242.11.42.135)  8.780 ms * 240.4.12.14 (240.4.12.14)  8.941 ms
 9  242.11.43.133 (242.11.43.133)  7.046 ms 242.11.43.3 (242.11.43.3)  8.611 ms 242.11.43.5 (242.11.43.5)  9.342 ms
10  142.251.250.56 (142.251.250.56)  7.545 ms 216.239.56.223 (216.239.56.223)  6.920 ms qro02s27-in-f14.1e100.net (142.251.34.206)  6.024 ms
```

### Observation

Traceroute displayed the network hops between my machine and the target.

Some hops may show `*` or timeouts because intermediate routers may not respond to traceroute packets.

---

# 4. Ports – Listening Services

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

### Observation

The command displayed services currently listening on TCP/UDP ports.

### Example

```text
Port: 22
Service: SSH
```

---

# 5. Name Resolution – DNS

### Command

```bash
dig google.com
```

### Output

```text
; <<>> DiG 9.20.18-1ubuntu2.1-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50418
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		242	IN	A	142.251.46.78

;; Query time: 2 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Tue Aug 11 07:17:50 UTC 2026
;; MSG SIZE  rcvd: 55
```

### Observation

DNS resolved `google.com` to an IP address.

---

# 6. HTTP Check

### Command

```bash
curl -I https://google.com
```

### Output

```text
HTTP/2 301
location: https://www.google.com/
content-type: text/html; charset=UTF-8
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-DVPrnoALeQHtaw8yQcwrwQ' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
date: Tue, 11 Aug 2026 07:18:37 GMT
expires: Thu, 10 Sep 2026 07:18:37 GMT
cache-control: public, max-age=2592000
server: gws
content-length: 220
x-xss-protection: 0
x-frame-options: SAMEORIGIN
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

### Observation

The HTTP response returned status code:

```text
HTTP/2 301
```

The URL you requested has permanently moved to another URL.

---

# 7. Connections Snapshot

### Command

```bash
netstat -an | head
```

### Output

```text
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0    760 172.31.42.70:22         122.161.69.202:21269    ESTABLISHED
tcp        0      0 172.31.42.70:41904      54.218.137.160:80       TIME_WAIT
tcp        0      0 172.31.42.70:22         85.217.140.54:45303     SYN_RECV
tcp6       0      0 :::22                   :::*                    LISTEN
udp        0      0 127.0.0.1:323           0.0.0.0:*
```

### Observation

The command displayed active and listening network connections.

---

# Part 3 – Mini Task: Port Probe

## Step 1 – Identify a Listening Port

From `ss -tulpn`, I identified:

```text
Port: 22
Service: SSH
```

---

## Step 2 – Test the Port

### Command

```bash
nc -zv localhost <PORT>
```

### Output

```text
Connection to localhost (127.0.0.1) 22 port [tcp/ssh] succeeded!
```

### Observation

The port was `reachable`.

---

## Step 3 – Next Check

If the port is not reachable, I would check:

```bash
systemctl status <service>
```

Then:

```bash
ss -tulpn
```

And if necessary:

```bash
sudo ufw status
```

---

# Reflection

## Which command gives the fastest signal when something is broken?

I would start with:

```bash
ping <target>
```

for basic network reachability.

For a web application, I would use:

```bash
curl -I <URL>
```

because it quickly tells me whether the HTTP service is responding.

---

## What layer would I inspect if DNS fails?

I would first investigate the **Application layer**, because DNS operates at the application layer.

I would check DNS configuration and test resolution using:

```bash
dig google.com
```

or:

```bash
nslookup google.com
```

---

## What layer would I inspect if HTTP 500 appears?

HTTP 500 means the request reached the web server/application but the server encountered an internal error.

I would investigate the **Application layer** and then check application/service logs.

---

# Two Follow-up Checks in a Real Incident

### 1. Check Service Status

```bash
systemctl status <service>
```

### 2. Check Service Logs

```bash
journalctl -u <service> -n 50
```

---

# Commands Practiced

```bash
hostname -I

ping google.com

traceroute google.com

ss -tulpn

dig google.com

curl -I https://google.com

netstat -an | head

nc -zv localhost <PORT>
```

---

# What I Learned

1. Networking troubleshooting can be approached layer by layer, starting with basic connectivity and moving toward DNS, ports, and applications.

2. `ping`, `traceroute`, `dig`, `ss`, and `curl` provide different types of information and should be used for different troubleshooting questions.

3. A successful network connection does not always mean the application is healthy. DNS, ports, HTTP responses, and application logs may need to be checked separately.
