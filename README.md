# What's all this, then?

This is a rather crude and undoubtedly buggy set of scripts to use Docker containers to set up lab environments for students to use as virtual private servers.

The end goal is for students to be able to SSH to a "server", have full root access *just* to their own server, and be able to host a website on ports 80 (HTTP) and 443 (HTTPS).

Having SSH access also means that students can use Visual Studio Code's [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension to develop code directly on the remote server, using a local IDE/text editor.

The software used to facilitate this includes a web proxy called [Traefik](https://traefik.io/traefik/), and an SSH interceptor called [sshpiper](https://github.com/tg123/sshpiper/). The SSH interception is particularly hairy, because it makes it hard to verify an end-to-end secure SSH connection and I'm sure this tool hasn't been audited for security, so I don't recommend its use in production, but in a lab environment, I'm sufficiently comfortable that it meets my requirements. Do your own due diligence to determine if it's a good fit for you.

This software stack also includes [Screego](https://screego.net/), a web-based screen sharing tool, [Forgejo](https://forgejo.org/) an open-source code forge, and a simple HTTP nginx file server for sharing files with students.

## Architecture

The Docker Compose file starts several services:

* reverse-proxy (Traefik)
* sshpiper
* files (nginx web server for sharing files)
* screego
* forgejo

Most of these have been explained above, but here's more detail about how we use Traefik and sshpiper.

Both Traefik and sshpiper are configured to take advantage of Docker container labels to determine whether to allow traffic through to them. Based on these labels, Traefik knows that when it receives a web request for `http://some-address.TOP_DOMAIN` (https should also work, albeit with a self-signed certificate), it should forward that request through to port 80 of the container called `some-address`. Likewise, when sshpiper receives an SSH connection with username `some-username`, it will forward that connection through to the container called `some-username`.

Containers for each usera re configured using `secrets/users.psv` (an example is available at `secrets/users.psv.example`. Each line is a sequence of username, hostname, and password, separated by the pipe character:

```
username|hostname1234|password
```

The username and password are used to access the container via SSH, and the container should be available via the DNS name `username` or `hostname1234`, or both. `hostname1234` is the hostname given to the Docker container internally, and what will appear on the shell prompt when a user SSHes in. I usually set the username and hostname to the same value for simplicity.

> [!IMPORTANT]
> NOTE: This whole configuration also has an external DNS dependency: It assumes that `anything.TOP_DOMAIN`, where `TOP_DOMAIN` is configurable in the `.env` file (see `.env.example`) resolves to the server hosting the lab system.

# Set up:

> [!WARNING]
> I'm pretty sure there's a bug here somewhere when running on macOS, but I've not pinned it down yet; it causes an issue when trying to start containers for non-existing users and not having permission to configure their home directory properly.

1. Start with a server (most of my testing is done on Linux, with a little on macOS) which is accessible via SSH and HTTP(S) from student machines
2. Install Docker and Docker Compose (Docker Desktop would do the job)
3. Clone this repository
4. Build the student container images using `./build_student_image`
5. Copy `.env.example` to `.env` and change the `TOP_DOMAIN` variable as needed. Every website will be available at `website_name.TOP_DOMAIN`.
6. Create a Docker network for all containers: `docker network create --attachable lab`
7. Start the base infrastructure with `docker compose up -d`
8. Copy `secrets/users.psv.example` to `secrets/users.psv` and populate with usernames/hostnames/passwords, pipe-separated.
9. Start up user containers using `./start_lab_hosts`
10. To stop containers, run `./trash_docker_data`. Note that using the current set-up, because user data is stored in the `lab_homes/` directory rather than in Docker volumes, this will *not* be lost or deleted as a result of running this script
