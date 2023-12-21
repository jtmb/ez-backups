<h1 align="center">
  <a href="https://github.com/jtmb">
    <img src="https://avatars.githubusercontent.com/u/86915618?v=4" alt="Logo" width="125" height="125">
  </a>
</h1>

<div align="center">
  <b>EZ Backups</b> - Keep your selfhosted environment updated.
  <br />
  <br />
  <a href="https://github.com/jtmb/ip_check/issues/new?assignees=&labels=bug&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/jtmb/ip_check/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  .
  <a href="https://hub.docker.com/repository/docker/jtmb92/cloudflare_ip_checker/general">Docker Hub</a>
</div>
<br>
<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
    - [Highlighted Features](#highlighted-features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
    - [Docker Image](#docker-image)
    - [Running on Docker](#running-on-docker)
    - [Running on Docker Compose](#running-on-docker-compose)
    - [Running on Docker Swarm](#running-on-docker-swarm)
- [Environment Variables Explained](#environment-variables-explained)
    - [Changing Login Credentials](#changing-login-credentials)
- [Contributing](#contributing)
- [License](#license)

</details>
<br>

---

### <h1>About</h1>

An Alpine-based microservice within Docker, designed to seamlessly backup your desired files or directories across a variety of local and cloud platforms.

### Highlighted Features:

- <b>Streamlined addition of monitored A records</b> in cases of accidental removal.
- <b>Automatic identification of changes in the forward-facing IP</b> facilitating the prompt update of A records with the new IP address.
- <b>User-friendly customization</b> achieved through a concise set of environment variables.
- <b>Integration with Discord</b> for simple alert notifications.
- <b>Fast</b> - API request total time on average is less than a second.
- <b>Lightweight</b> - Alpine Container keeps the image size below 15 MB.
- <b>Scalable</b> - Built with scale in mind, Docker Swarm compatible.
- <b>NEW</b> - Now includes a fully featured admin dashboard with login session support.


#### Example:
![Alt text](src/img/image.png))
![Example](src/img/example.png)

#### Discord Alerting:

![Discord](src/img/discord.png)

## Prerequisites

- Docker installed on your system
- A Discord webhook URL
- A Cloudflare API Key
- The ZONE ID for your Cloudflare instance

### <h2>Getting Started</h2>
### [Docker Image](https://hub.docker.com/r/jtmb92/ez-backups)
```docker
 docker pull jtmb92/cloudflare-ip-checker
```

### [Docker Image with UI Dashboard](https://hub.docker.com/r/jtmb92/cloudflare_ip_checker)
```docker
 docker pull jtmb92/cloudflare-ip-checker:UI
```
### Running on docker
A simple docker run command gets your instance running.
```shell
docker run --name ip-checker-container \
    -e EMAIL="your-email@example.com" \
    -e API_KEY="your-cloudflare-api-key" \
    -e ZONE_ID="your-cloudflare-zone-id" \
    -e WEBHOOK_URL="your-discord-webhook-url" \
    -e DNS_RECORDS="my.site.com/A site.com/A" \
    -e REQUEST_TIME=120 \
jtmb92/cloudflare-ip-checker
```
### Running on docker-compose
Run on Docker Compose (this is the recommended way) by running the command "docker compose up -d".
```yaml
version: '3.8'
services:
    ip-checker:
        image: jtmb92/cloudflare-ip-checker
        volumes:
         - /path/to/logs:/data/logs 
        environment:
            EMAIL: 'your-email@example.com'
            API_KEY: 'your-cloudflare-api-key'
            ZONE_ID: 'your-cloudflare-zone-id'
            WEBHOOK_URL: 'your-discord-webhook-url'
            DNS_RECORDS: 'my.site.com/A site.com/A'
            REQUEST_TIME: '2m'
            DASHBOARD_USER: admin
            DASHBOARD_PASSWORD: admin
```
<b>NEW</b> Run on Docker Compose with UI (this is the recommended way) by running the command "docker compose up -d".

```yaml
version: '3.8'
services:
    ip-checker:
        image: jtmb92/cloudflare-ip-checker:UI
        volumes:
         - /path/to/logs:/data/logs
        ports:
        - '8081:8080'
        environment:
            EMAIL: 'your-email@example.com'
            API_KEY: 'your-cloudflare-api-key'
            ZONE_ID: 'your-cloudflare-zone-id'
            WEBHOOK_URL: 'your-discord-webhook-url'
            DNS_RECORDS: 'my.site.com/A site.com/A'
            REQUEST_TIME: '2m'
```

### Running on docker-compose with custom dockerfile
Similar to the above example, the key difference here is that we are running with the build: argument instead of the image: argument. The . essentially builds the Docker image from a local Dockerfile located in the root directory where the docker compose up -d command was run.
```yaml
version: '3.8'
services:
    ip-checker:
        build: .
        volumes:
         - /path/to/logs:/data/logs 
        environment:
            EMAIL: 'your-email@example.com'
            API_KEY: 'your-cloudflare-api-key'
            ZONE_ID: 'your-cloudflare-zone-id'
            WEBHOOK_URL: 'your-discord-webhook-url'
            DNS_RECORDS: 'my.site.com/A site.com/A'
            REQUEST_TIME: '120'
```
### Running on Docker Swarm
**Meant for advanced users**
Here's an example using the Loki driver to ingress logging over a custom Docker network while securely passing in ENV vars.
```yaml
version: "3.8"
services:
    cloudflare-ip-checker:
        image: "jtmb92/cloudflare_ip_checker"
        restart: always
        networks:
            - container-swarm-network
        volumes:
         - /path/to/logs:/data/logs 
        environment:
            API_KEY:  ${cf_key}
            ZONE_ID: ${cf_zone_id}
            WEBHOOK_URL: ${discord_webook}
            DNS_RECORDS: 'my.site.com/A site.com/A'
            REQUEST_TIME: "2m"
            EMAIL: ${email}
        deploy:
            replicas: 1
            placement:
                max_replicas_per_node: 1
        logging:
            driver: loki
            options:
                loki-url: "http://localhost:3100/loki/api/v1/push"
                loki-retries: "5"
                loki-batch-size: "400"
networks:
    container-swarm-network:
     external: true
```

jtmb92/cloudflare_ip_checker

## Environment Variables explained

```yaml
    scheduled_hour: '5'
```  
The hour to run the script (24 hour format)
```yaml
   scheduled_minute: '59'
```     
The minute value to run the script
```yaml
    local_backup_method: rsync #zip or rsync
```      
Local backup method to be used 
```yaml
    WEBHOOK_URL: 'https://discord.com/api/webhooks/<redacted>/<redacted>'
```     
The URL of your Discord webhook. This is where notifications will be sent when IP changes are detected.
```yaml
    source_dir: '/test/test1 /test/test2 /test/test3' #example of multiple list format entries
```      
A space-separated list of directories (local) to be backed up.
```yaml
    backup_destination: /test/test4 
```    
The destination to backup files to. Child folders will be created as necessary.
```yaml
    TZ: America/New_York
```
Set the timezone.    

## Contributing

First off, thanks for taking the time to contribute! Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Please try to create bug reports that are:

- _Reproducible._ Include steps to reproduce the problem.
- _Specific._ Include as much detail as possible: which version, what environment, etc.
- _Unique._ Do not duplicate existing opened issues.
- _Scoped to a Single Bug._ One bug per report.

## License

This project is licensed under the **GNU GENERAL PUBLIC LICENSE v3**. Feel free to edit and distribute this template as you like.

See [LICENSE](LICENSE) for more information.