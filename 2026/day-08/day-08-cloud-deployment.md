# Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

## Objective

Deploy a Linux server on the cloud, connect using SSH, install Nginx, verify the web server is accessible over the internet, and collect Nginx logs.

---


# Part 1 – Launch Cloud Instance & SSH Access

## Step 1 – Connect to the Server

### Command

```bash
ssh -i your-key.pem ubuntu@<YOUR_PUBLIC_IP>
```

### Output

```text
Welcome to Ubuntu 24.04 LTS
ubuntu@ip-172-31-xx-xx:~$
```

### Observation

Successfully connected to the cloud server using SSH.

📸 Screenshot Required

- SSH connection established.

---

# Part 2 – Update the Server

## Update Package List

```bash
sudo apt update
```

### Observation

Package list updated successfully.

---

## Upgrade Installed Packages

```bash
sudo apt upgrade -y
```

### Observation

Installed the latest package updates.

---

# Part 3 – Install Docker

## Install Docker

```bash
sudo apt install docker.io -y
```

---

## Verify Docker Installation

```bash
docker --version
```

### Output

```text
Docker version 29.1.3
```

### Observation

Docker installed successfully.

---

## Check Docker Service

```bash
sudo systemctl status docker
```

### Observation

Docker service is active and running.

---

# Part 4 – Install Nginx

## Install Nginx

```bash
sudo apt install nginx -y
```

### Observation

Nginx installed successfully.

---

## Verify Nginx Service

```bash
sudo systemctl status nginx
```

### Output

```text
Active: active (running)
```

### Observation

Confirmed that the Nginx service is running.

---

## Enable Nginx at Boot

```bash
sudo systemctl enable nginx
```

### Observation

Nginx will automatically start after every reboot.

---

# Part 5 – Configure Security Group

Allowed the following inbound rules:

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | SSH | Remote login |
| 80 | HTTP | Web server |
| 443 | HTTPS | Secure web traffic (optional) |

### Observation

HTTP traffic is now allowed.

---

# Part 6 – Verify Web Server

## Local Test

```bash
curl localhost
```

### Observation

Received the default Nginx HTML page.

---

## Browser Test

Opened:

```text
http://16.146.78.204
```

### Result

The default **Welcome to Nginx!** page loaded successfully.

📸 Screenshot Required

- Nginx welcome page in browser.

---

# Part 7 – View Nginx Logs

## Access Log

```bash
cat /var/log/nginx/access.log
```

### Observation

Displayed HTTP requests received by the server.

---

## Error Log

```bash
cat /var/log/nginx/error.log
```

### Observation

No critical errors found.

---

# Part 8 – Save Logs

## Save Access Log

```bash
cp /var/log/nginx/access.log ~/nginx-logs.txt
```

### Verify

```bash
cat ~/nginx-logs.txt
```

### Observation

Successfully copied the access log.

📸 Screenshot Required

- Contents of **nginx-logs.txt**

---

# Part 9 – Download Log File

Run on your local machine:

```bash
scp -i your-key.pem ubuntu@<YOUR_PUBLIC_IP>:~/nginx-logs.txt .
```

### Observation

Downloaded the log file successfully.

---

# Commands Used

```bash
ssh -i your-key.pem ubuntu@<YOUR_PUBLIC_IP>

sudo apt update

sudo apt upgrade -y

sudo apt install docker.io -y

docker --version

sudo systemctl status docker

sudo apt install nginx -y

sudo systemctl status nginx

sudo systemctl enable nginx

curl localhost

cat /var/log/nginx/access.log

cat /var/log/nginx/error.log

cp /var/log/nginx/access.log ~/nginx-logs.txt

cat ~/nginx-logs.txt

scp -i your-key.pem ubuntu@<YOUR_PUBLIC_IP>:~/nginx-logs.txt .
```

---

# Files Created

```
nginx-logs.txt
```

---

# Screenshots Included

- SSH connection to the EC2 instance
- Nginx welcome page in the browser
- Contents of `nginx-logs.txt`

---

# Key Learnings

- Connected securely to a cloud server using SSH.
- Updated the operating system packages.
- Installed and verified Docker.
- Installed and configured Nginx.
- Verified web server accessibility from the internet.
- Collected and exported Nginx access logs.
- Downloaded logs from the remote server using SCP.
