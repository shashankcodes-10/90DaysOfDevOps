# Day 32 – Docker Volumes & Networking

## Overview

Today's practice focused on two important Docker concepts:

* **Docker Volumes** for persistent data storage
* **Docker Networking** for communication between containers

The main goal was to understand what happens to container data when a container is removed and how containers communicate using Docker networks.

---

# Task 1 – Container Data Persistence

## Running MySQL Container

I started a MySQL 5.7 container with a root password:

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql:5.7
```

Check running containers:

```bash
docker ps
```

Access the MySQL container:

```bash
docker exec -it <container-id> bash
```

Connect to MySQL:

```bash
mysql -u root -p
```

## Create Database

```sql
SHOW DATABASES;

CREATE DATABASE tws_db;

USE tws_db;
```

## Create Table

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
```

## Insert Data

```sql
INSERT INTO users (name, email)
VALUES ('Shashank', 'shashank@example.com');
```

Verify the data:

```sql
SELECT * FROM users;
```

Output:

```text
+----+----------+----------------------+
| id | name     | email                |
+----+----------+----------------------+
|  1 | Shashank | shashank@example.com |
+----+----------+----------------------+
```

## Remove the Container

```bash
docker stop <container-id>
docker rm <container-id>
```

Then I started a completely new MySQL container:

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=root mysql:5.7
```

After connecting to the new container:

```sql
SHOW DATABASES;
```

The previously created `tws_db` database was not present.

### Observation

Container storage is tied to the container's writable layer. When the container is removed, data stored only inside that layer is removed as well.

**This demonstrates why persistent storage is required for databases.**

---

# Task 2 – Named Volumes

## Create a Named Volume

```bash
docker volume create mysql-testing
```

List Docker volumes:

```bash
docker volume ls
```

Inspect the volume:

```bash
docker volume inspect mysql-testing
```

## Run MySQL with the Volume

```bash
docker run -d \
  -e MYSQL_ROOT_PASSWORD=root \
  -v mysql-testing:/var/lib/mysql \
  mysql:5.7
```

The volume is mounted at MySQL's data directory:

```text
/var/lib/mysql
```

## Create Database and Data

Connect to the container:

```bash
docker exec -it <container-id> bash
```

Then:

```bash
mysql -u root -p
```

Create a database:

```sql
CREATE DATABASE mydb;

USE mydb;
```

Create the table:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
```

Insert data:

```sql
INSERT INTO users (name, email)
VALUES ('Shashank', 'shashank@example.com');
```

Verify:

```sql
SELECT * FROM users;
```

Output:

```text
+----+----------+----------------------+
| id | name     | email                |
+----+----------+----------------------+
|  1 | Shashank | shashank@example.com |
+----+----------+----------------------+
```

## Remove the Container

```bash
docker stop <container-id>
docker rm <container-id>
```

## Start a New Container Using the Same Volume

```bash
docker run -d \
  -e MYSQL_ROOT_PASSWORD=root \
  -v mysql-testing:/var/lib/mysql \
  mysql:5.7
```

Connect to MySQL:

```bash
docker exec -it <container-id> bash
mysql -u root -p
```

Check databases:

```sql
SHOW DATABASES;
```

The `mydb` database was still available.

Check the table:

```sql
USE mydb;

SHOW TABLES;
```

Verify the data:

```sql
SELECT * FROM users;
```

Output:

```text
+----+----------+----------------------+
| id | name     | email                |
+----+----------+----------------------+
|  1 | Shashank | shashank@example.com |
+----+----------+----------------------+
```

### Observation

The container was removed, but the named volume remained.

When the new MySQL container was started with the same volume, the database and its data were available again.

### Important Commands

```bash
docker volume ls
```

```bash
docker volume inspect mysql-testing
```

### Key Learning

A **named volume** is managed by Docker and is independent of the lifecycle of a container.

```text
Container
    |
    | mounts
    v
mysql-testing volume
    |
    v
/var/lib/mysql
```

Removing the container does not remove the named volume.

---

# Task 3 – Bind Mounts

## Create Host Directory

```bash
mkdir volumes-test
cd volumes-test
```

Create the HTML file:

```bash
vim index.html
```

Example content:

```html
<h1>Hello</h1>
```

Check the directory:

```bash
ls
```

Output:

```text
index.html
```

Check the absolute path:

```bash
pwd
```

Example:

```text
/Users/shashank10/volumes-test
```

## Run Nginx with a Bind Mount

```bash
docker run -d \
  -v /Users/shashank10/volumes-test:/usr/share/nginx/html \
  -p 80:80 \
  nginx
```

The host directory was mounted directly into Nginx's web directory.

Open the following in a browser:

```text
http://localhost
```

The `index.html` file from the host directory is served by Nginx.

## Modify the HTML File

Edit the file on the host:

```bash
vim /Users/shashank10/volumes-test/index.html
```

After saving the changes, refresh the browser.

The updated content is reflected immediately because the host directory is directly mounted into the container.

## Named Volume vs Bind Mount

| Named Volume                            | Bind Mount                                                      |
| --------------------------------------- | --------------------------------------------------------------- |
| Managed by Docker                       | Managed by the user/host                                        |
| Docker decides the storage location     | User specifies the host path                                    |
| Good for application/database data      | Useful for source code and configuration                        |
| Example: `mysql-testing:/var/lib/mysql` | Example: `/Users/shashank10/volumes-test:/usr/share/nginx/html` |

### Key Learning

A bind mount connects a specific directory or file from the host machine directly to a location inside the container.

---

# Task 4 – Docker Networking Basics

## List Docker Networks

```bash
docker network ls
```

Example networks:

```text
NETWORK ID     NAME      DRIVER    SCOPE
350d2168c4c2   bridge    bridge    local
e2ef3367c548   host      host      local
51bc879e334f   kind      bridge    local
c98e6e72ff42   none      null      local
```

## Inspect the Default Bridge Network

```bash
docker inspect bridge
```

The default bridge network used the following subnet:

```text
172.17.0.0/16
```

## Run Containers on Default Bridge

Two containers were started on the default bridge network:

```bash
docker run -d \
  -v /Users/shashank10/volumes-test:/usr/share/nginx/html \
  --name first-cont \
  -p 80:80 \
  nginx
```

```bash
docker run -d \
  -p 3306:3306 \
  --name sec-cont \
  -e MYSQL_ROOT_PASSWORD=ROOT \
  mysql:5.7
```

The containers were running on Docker's default `bridge` network.

### Name-Based Communication

The default bridge network does not provide the same automatic container-name DNS resolution as a user-defined bridge network.

Therefore, using the container name:

```text
sec-cont
```

does not automatically resolve to the MySQL container on the default bridge network.

### IP-Based Communication

Containers on the default bridge network receive IP addresses from the bridge subnet.

Example:

```text
172.17.0.0/16
```

Container-to-container communication can therefore be performed using the container's IP address.

---

# Task 5 – Custom Docker Network

## Create a Custom Network

```bash
docker network create test
```

Verify:

```bash
docker network ls
```

The custom network appears as:

```text
test    bridge    local
```

## Run Containers on the Custom Network

Nginx container:

```bash
docker run -d \
  -v /Users/shashank10/volumes-test:/usr/share/nginx/html \
  --name first-cont \
  -p 80:80 \
  --network=test \
  nginx
```

MySQL container:

```bash
docker run -d \
  -p 3306:3306 \
  --name sec-cont \
  -e MYSQL_ROOT_PASSWORD=ROOT \
  --network=test \
  mysql:5.7
```

## Inspect the Custom Network

```bash
docker inspect test
```

The network assigned IP addresses to the containers.

Example:

```text
first-cont → 172.19.0.2
sec-cont   → 172.19.0.3
```

## Container Name Resolution

On a user-defined bridge network, Docker provides automatic DNS-based name resolution.

Therefore, containers connected to the same custom network can communicate using their container names.

For example:

```text
sec-cont
```

resolves to the MySQL container's IP address within the `test` network.

### Why Custom Networks Are Better

Custom bridge networks provide:

* Automatic DNS resolution
* Container-name based communication
* Network isolation
* Easier application configuration
* Better separation between different applications

Instead of depending on changing container IP addresses, an application can connect to:

```text
sec-cont:3306
```

The container name remains the same even if the container's IP changes.

---

# Task 6 – Putting Volumes and Networking Together

The practice combined the two main concepts:

```text
                Docker Host
                     |
        +------------+------------+
        |                         |
   MySQL Container           Application
        |                      Container
        |                         |
        v                         |
  mysql-testing                   |
      Volume                      |
        |                         |
        +-----------+-------------+
                    |
                test network
```

## Database Container

The MySQL container can use both a custom network and a named volume:

```bash
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=ROOT \
  -v mysql-testing:/var/lib/mysql \
  --network=test \
  mysql:5.7
```

## Application Container

An application container can be connected to the same network:

```bash
docker run -d \
  --name app \
  --network=test \
  nginx
```

The application can communicate with MySQL using the database container's name:

```text
mysql-db:3306
```

There is no need to hard-code the database container's IP address.

---

# Important Concepts Learned

## 1. Container Storage

Without a volume:

```text
Container removed
       ↓
Container writable data removed
       ↓
Database data lost
```

## 2. Named Volume

With a named volume:

```text
Container
    ↓
Named Volume
    ↓
Database Data
```

The volume survives container removal.

## 3. Bind Mount

```text
Host Directory
      ↓
Container Directory
```

Changes made on the host can immediately be reflected inside the container.

## 4. Default Bridge Network

The default bridge network provides container networking, but automatic container-name DNS resolution is not available in the same way as user-defined bridge networks.

## 5. Custom Bridge Network

A custom bridge network provides:

```text
Container A
     |
     | container-name DNS
     |
Container B
```

This makes application-to-database communication easier.

---

# Useful Docker Commands

### Containers

```bash
docker ps
docker run
docker stop
docker rm
docker exec
```

### Volumes

```bash
docker volume create <volume-name>
docker volume ls
docker volume inspect <volume-name>
```

### Networks

```bash
docker network ls
docker network create <network-name>
docker network inspect <network-name>
```

### Mount a Named Volume

```bash
docker run -v volume_name:/container/path image
```

### Bind Mount

```bash
docker run -v /host/path:/container/path image
```

### Connect Container to a Custom Network

```bash
docker run --network=<network-name> image
```

---

# Key Takeaways

* Containers are ephemeral by default.
* Removing a container removes data stored only in its writable layer.
* Named volumes provide persistent storage.
* Named volumes are especially useful for databases.
* Bind mounts connect host directories directly to containers.
* Docker provides default networks such as `bridge`, `host`, and `none`.
* The default bridge network does not provide automatic name-based DNS resolution like user-defined bridge networks.
* Custom bridge networks provide automatic container-name resolution.
* Containers on the same custom network can communicate using container names.
* Container names are preferred over hard-coded IP addresses because container IPs can change.
* Volumes and networking together allow Docker applications to have both **persistent data** and **reliable container-to-container communication**.

---

# Practical Summary

The complete flow practiced in this task was:

```text
                    Docker
                      |
        +-------------+-------------+
        |                           |
     Volumes                    Networking
        |                           |
   +----+----+                 +----+----+
   |         |                 |         |
Named      Bind              Default   Custom
Volume     Mount             Bridge    Network
   |         |                           |
Database   Nginx                    Name-based
Data       Files                    Communication
```

This practice demonstrated two essential Docker concepts required for real-world containerized applications: **persistent storage using volumes** and **service communication using Docker networks**.
