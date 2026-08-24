# Day 31 – Dockerfile: Build Your Own Images

## Task

Today's goal was to understand how to create custom Docker images using Dockerfiles.

During this practical, I worked with:

* Dockerfile instructions
* Building custom Docker images
* `CMD` and `ENTRYPOINT`
* Nginx custom images
* Port mapping
* `.dockerignore`
* Docker build context
* Docker layer caching
* Verifying files inside containers

---

# Task 1 – Your First Dockerfile

## Objective

Create a custom Ubuntu-based Docker image that:

* Uses Ubuntu as the base image
* Installs `curl`
* Sets the working directory
* Prints a custom message when the container starts

---

## Project Structure

```text
my-first-image/
├── Dockerfile
```

---

## Dockerfile

```dockerfile
FROM ubuntu

WORKDIR /app

RUN apt-get update && \
    apt-get install curl -y

CMD ["echo", "Hello from my custom image!"]
```

### Explanation

#### `FROM ubuntu`

Specifies Ubuntu as the base image.

```dockerfile
FROM ubuntu
```

Every Dockerfile needs a base image from which the custom image is built.

---

#### `WORKDIR /app`

Sets `/app` as the working directory inside the image.

```dockerfile
WORKDIR /app
```

Any subsequent commands operate relative to this directory unless another directory is specified.

---

#### `RUN`

Installs `curl` during the image build.

```dockerfile
RUN apt-get update && \
    apt-get install curl -y
```

`RUN` executes commands while the Docker image is being built.

---

#### `CMD`

Defines the default command that runs when a container is started.

```dockerfile
CMD ["echo", "Hello from my custom image!"]
```

---

## Build the Image

Command used:

```bash
docker build -t my-ubuntu:v1 .
```

The image was successfully built and tagged as:

```text
my-ubuntu:v1
```

The build also demonstrated Docker's build process and layer caching.

---

## Run the Image

Command:

```bash
docker run --name ubuntu-cont my-ubuntu:v1
```

Output:

```text
Hello from my custom image!
```

This verified that the `CMD` instruction executes when the container starts.

---

# Task 2 – Dockerfile Instructions

The Dockerfiles used during the practical demonstrated the main Dockerfile instructions:

```dockerfile
FROM
RUN
COPY
WORKDIR
EXPOSE
CMD
```

---

## `FROM`

Defines the base image.

Example:

```dockerfile
FROM ubuntu
```

or:

```dockerfile
FROM nginx:alpine
```

---

## `RUN`

Executes commands during image creation.

Example:

```dockerfile
RUN apt-get update && \
    apt-get install curl -y
```

The result of a `RUN` command becomes part of the image.

---

## `COPY`

Copies files from the Docker build context into the image.

Example:

```dockerfile
COPY index.html .
```

---

## `WORKDIR`

Sets the working directory.

Example:

```dockerfile
WORKDIR /app
```

For the Nginx image:

```dockerfile
WORKDIR /usr/share/nginx/html
```

---

## `EXPOSE`

Documents the port that the containerized application listens on.

Example:

```dockerfile
EXPOSE 80
```

`EXPOSE` does not publish the port to the host. Port publishing is done with `docker run -p`.

---

## `CMD`

Defines the default command executed when a container starts.

Example:

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

---

# Task 3 – CMD vs ENTRYPOINT

## CMD

A Dockerfile can define a default command using:

```dockerfile
CMD ["echo", "hello"]
```

The command provided during `docker run` can replace the default `CMD`.

Conceptually:

```text
Dockerfile:
CMD ["echo", "hello"]

docker run image
        ↓
echo hello

docker run image <custom-command>
        ↓
custom command replaces CMD
```

---

## ENTRYPOINT

For the ENTRYPOINT practical, I created a separate Dockerfile.

### Dockerfile.entrypoint

```dockerfile
FROM ubuntu

WORKDIR /app

ENTRYPOINT ["echo"]
```

The image was built using:

```bash
docker build -t ubuntu-entrypoint -f Dockerfile.entrypoint .
```

The build completed successfully.

---

## Run ENTRYPOINT Image

Command used:

```bash
docker run --name entrypoint-cont ubuntu-entrypoint "Hello , this is entrypoint argument"
```

Output:

```text
Hello , this is entrypoint argument
```

The argument was passed to the `ENTRYPOINT` command.

---

## CMD vs ENTRYPOINT

| CMD                                                      | ENTRYPOINT                                                         |
| -------------------------------------------------------- | ------------------------------------------------------------------ |
| Provides a default command                               | Defines the main executable                                        |
| Can easily be replaced at runtime                        | Runtime arguments are normally appended                            |
| Useful when the container should have a default behavior | Useful when the container should behave like a specific executable |
| Can be used for default arguments                        | Helps make the executable fixed                                    |

### Simple Example

#### CMD

```dockerfile
CMD ["echo", "hello"]
```

The runtime command can replace the CMD.

#### ENTRYPOINT

```dockerfile
ENTRYPOINT ["echo"]
```

Additional runtime arguments are passed to `echo`.

---

# Task 4 – Build a Simple Web App Image

## Static HTML

I created an `index.html` file for the static website.

Example content:

```html
<h1>hello this is a testing file</h1>
```

---

## Project Structure

```text
my-first-image/
├── Dockerfile
├── Dockerfile.entrypoint
├── Dockerfile.nginx
└── index.html
```

---

## Dockerfile.nginx

```dockerfile
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY index.html .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Explanation

The Dockerfile:

1. Uses `nginx:alpine`
2. Changes the working directory to the Nginx web root
3. Copies `index.html` into that directory
4. Documents port `80`
5. Starts Nginx in the foreground

---

## Build the Image

Command used:

```bash
docker build -t nginx-server -f Dockerfile.nginx .
```

The image was successfully built. The build output showed:

```text
[2/3] WORKDIR /usr/share/nginx/html
[3/3] COPY index.html .
```

---

## Tag the Image

The image was tagged as:

```bash
docker image tag nginx-server my-website:v1
```

---

## Run the Website

Command:

```bash
docker run -d -p 80:80 my-website:v1
```

The container started successfully with the following port mapping:

```text
0.0.0.0:80->80/tcp
```

The application can then be accessed through:

```text
http://localhost
```

---

# Task 5 – `.dockerignore`

## Why `.dockerignore` Is Used

A `.dockerignore` file specifies files and directories that should not be sent as part of the Docker build context.

This is useful for:

* Reducing build context size
* Preventing unnecessary files from entering the image
* Keeping sensitive files such as `.env` out of the build context
* Improving build performance

---

## `.dockerignore`

The practical used ignore patterns such as:

```text
*.env
*.txt
```

The `.dockerignore` file was used while building the image.

---

## Build Context

During the Docker build, Docker reported the build context being transferred:

```text
transferring context: 173B
```

This demonstrates that Docker sends the build context to the Docker daemon/build system and `.dockerignore` controls what is included.

---

## Verify Ignored Files

After running the container, I entered the Nginx container using:

```bash
docker exec -it 1a23ce45 sh
```

Then checked:

```bash
ls -la
```

The `/app` directory contained no copied project files:

```text
/app # ls -la

total 8
drwxr-xr-x    2 root     root     4096 ...
drwxr-xr-x    1 root     root     4096 ...
```

This demonstrated the effect of `.dockerignore` on the files being copied into the image.

---

# Task 6 – Docker Build Context

The `.` at the end of the build command represents the Docker build context.

Example:

```bash
docker build -t dockerignore-prac .
```

Here:

```text
. → Current directory
```

Docker uses this directory as the build context.

Files referenced by `COPY` and `ADD` must come from within the build context and must not be excluded by `.dockerignore`.

---

# Docker Build Cache

Docker uses layer caching during image builds.

During the practical, the build output showed:

```text
CACHED [2/3] WORKDIR /app
```

This means Docker reused the previously built layer instead of executing the instruction again.

---

## Why Does Layer Order Matter?

Dockerfile instructions are processed sequentially and each instruction can create a layer.

If an early layer changes, subsequent layers may need to be rebuilt.

For example:

```dockerfile
FROM ubuntu

RUN apt-get update && apt-get install curl -y

COPY application-files .

CMD ["..."]
```

If the application files change, Docker can potentially reuse the expensive dependency installation layer.

This is why frequently changing instructions should generally be placed later in the Dockerfile.

---

# Dockerfile Best Practices Learned

## 1. Use a Suitable Base Image

Example:

```dockerfile
FROM nginx:alpine
```

Using a smaller base image can reduce the final image size when it meets the application's requirements.

---

## 2. Combine Related Commands

Instead of multiple independent package-management commands:

```dockerfile
RUN apt-get update
RUN apt-get install curl -y
```

combine them:

```dockerfile
RUN apt-get update && \
    apt-get install curl -y
```

This reduces unnecessary image layers and ensures the package index is updated before installation.

---

## 3. Use `.dockerignore`

Exclude unnecessary files from the build context.

Example:

```text
*.env
*.txt
```

For real projects, common exclusions include:

```text
node_modules
.git
*.md
.env
```

---

## 4. Order Instructions Carefully

Place stable instructions before frequently changing instructions.

For example:

```dockerfile
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY index.html .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

If only the HTML file changes, Docker can reuse the previous base-image and working-directory layers.

---

# Important Commands Practiced

## Build Images

```bash
docker build -t my-ubuntu:v1 .
```

```bash
docker build -t ubuntu-entrypoint -f Dockerfile.entrypoint .
```

```bash
docker build -t nginx-server -f Dockerfile.nginx .
```

```bash
docker build -t dockerignore-prac .
```

---

## Run Containers

```bash
docker run --name ubuntu-cont my-ubuntu:v1
```

```bash
docker run --name entrypoint-cont ubuntu-entrypoint "Hello , this is entrypoint argument"
```

```bash
docker run -d -p 80:80 my-website:v1
```

---

## Tag an Image

```bash
docker image tag nginx-server my-website:v1
```

---

## Execute Commands Inside Containers

```bash
docker exec -it <container> sh
```

```bash
docker exec -it <container> bash
```

---

## Check Running Containers

```bash
docker ps
```

---

# Key Learnings

### Dockerfile

A Dockerfile is a text file containing instructions used to build a Docker image.

```text
Dockerfile
    ↓
docker build
    ↓
Docker Image
    ↓
docker run
    ↓
Container
```

---

### `RUN` vs `CMD`

`RUN` executes during **image build time**.

```dockerfile
RUN apt-get update
```

`CMD` executes when the **container starts**.

```dockerfile
CMD ["echo", "Hello"]
```

---

### `COPY`

`COPY` transfers files from the Docker build context into the image.

```dockerfile
COPY index.html .
```

---

### `EXPOSE`

`EXPOSE` documents the port used by the application.

```dockerfile
EXPOSE 80
```

It does not publish the port to the host.

Publishing is done with:

```bash
docker run -p 80:80 image
```

---

### `WORKDIR`

`WORKDIR` sets the current working directory inside the image/container.

```dockerfile
WORKDIR /app
```

---

### `.dockerignore`

`.dockerignore` prevents unnecessary files from being included in the Docker build context.

This helps keep builds smaller, faster, and cleaner.

---

# Final Dockerfiles

## Dockerfile

```dockerfile
FROM ubuntu

WORKDIR /app

RUN apt-get update && \
    apt-get install curl -y

CMD ["echo", "Hello from my custom image!"]
```

---

## Dockerfile.entrypoint

```dockerfile
FROM ubuntu

WORKDIR /app

ENTRYPOINT ["echo"]
```

---

## Dockerfile.nginx

```dockerfile
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY index.html .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

# Final Project Structure

```text
day-31/
│
├── my-first-image/
│   ├── Dockerfile
│   ├── Dockerfile.entrypoint
│   ├── Dockerfile.nginx
│   └── index.html
│
└── day-31-dockerfile.md
```

---

# Conclusion

Day 31 helped me move from simply running existing Docker images to creating my own custom images.

I practiced writing Dockerfiles using `FROM`, `RUN`, `COPY`, `WORKDIR`, `EXPOSE`, `CMD`, and `ENTRYPOINT`. I also built an Ubuntu-based image, created an Nginx-based static website image, practiced port mapping, used `.dockerignore`, and observed Docker's build cache.

The most important concept from this practical was understanding that a Dockerfile is essentially a set of instructions used to construct an image layer by layer. Proper instruction ordering and the use of `.dockerignore` can make Docker builds more efficient.
