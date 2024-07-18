<h1 align="center">
  <a href="https://github.com/jtmb">
    <img src="https://avatars.githubusercontent.com/u/86915618?v=4" alt="Logo" width="125" height="125">
  </a>
</h1>

<div align="center">
  <b>EZ Backups</b> - Keep your selfhosted environment backed up.
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
    - [Backing up to remote locations](#backing-up-to-remote-locations)
    - [Performing an adhoc (one time) backup](#performing-an-adhoc-one-time-backup)
    ### 
- [Environment Variables Explained](#environment-variables-explained)
- [Contributing](#contributing)
- [License](#license)

</details>
<br>

---

### <h1>About</h1>

An Alpine-based microservice within Docker, designed to make backups easy.

This solution proves invaluable for those who self-host - allowing for easy automated backups to multiple locations.

### Highlighted Features:

- <b>Multiple backup locations! </b>Backup between cloud, local or both! 
- <b>Sync backups</b> back up to 3 locations at the same time!
- <b>User-friendly customization</b> achieved through a concise set of environment variables.
- <b>Integration with Discord</b> for simple alert notifications.
- <b>Fast</b> - API request total time on average is less than a second.
- <b>Lightweight</b> - Alpine Container keeps the image size below 15 MB.
- <b>Scalable</b> - Built with scale in mind, Docker Swarm compatible.


<!-- #### Example:
![Alt text](src/img/image.png))
![Example](src/img/example.png) -->

<!-- #### Discord Alerting:

![Discord](src/img/discord.png) -->

## Prerequisites

- Docker installed on your system

### <h2>Getting Started</h2>
### [Docker Image](https://hub.docker.com/r/jtmb92/ez-backups)
```docker
 docker pull jtmb92/ez-backups
```

### Running on docker
A simple docker run command gets your instance running.
```shell
docker run --name ez-backups \
        -e scheduled_hour: '15'
        -e scheduled_minute: '59'
        -e WEBHOOK_URL: 'your-discord-webhook'
        -e local_backup_method: rsync
        -e source_dir: '/test/test1 /test/test2 /test/test3'
        -e backup_destination: /test/test4
        -e TZ: America/New_York
jtmb92/ez-backups
```
### Running on docker-compose
Run on Docker Compose (this is the recommended way) by running the command "docker compose up -d".
```yaml
version: '3.8'
services:
    ez-backups:
        image: jtmb92/ez-backups
        container_name: ez-backups
        volumes:
         - /test:/test
        environment:
            scheduled_hour: '15'
            scheduled_minute: '59'
            WEBHOOK_URL: 'your-discord-webhook'
            local_backup_method: tar
            source_dir: '/test/test1 /test/test2 /test/test3'
            backup_destination: /test/test4
            TZ: America/New_York
```

### Backing up to remote locations
Backing up to remote locations now supported! 
Example of a remote backup to rsyncnet, using ssh keys:
```yaml
version: '3'

services:
  ez-backups:
    image: jtmb92/ez-backups:latest
    environment:
      scheduled_hour: '00'
      scheduled_minute: '12'
      WEBHOOK_URL: "${discord_webhook}"
      local_backup_method: tar
      remote_backup_method: rsync
      remote_host: ${rsync_net_user}.rsync.net
      remote_user: ${rsync_net_user}
      private_key_name: id_rsa_rsyncNet
      source_dir: '${container_volumes_location}'
      backup_destination: /test/test4
      TZ: America/New_York
    volumes:
      - ${container_volumes_location}:${container_volumes_location}
      - ${container_volumes_location}/ez-backups/.ssh:/.ssh
      - /test/test4:/test/test4
    deploy:
      replicas: 1
      placement:
        max_replicas_per_node: 1
    logging:
      driver: loki
      options:
        loki-url: "http://localhost:3003/loki/api/v1/push"
        loki-retries: "5"
        loki-batch-size: "400"
networks:
  container-swarm-network:
    external: true
```

### Performing an adhoc (one time) backup
Sometimes you may need to run a backup just once. You can do so by specifying the backup method with the "ezbackup" command:
```sh
docker exec -it CONTAINER_NAME ezbackup local_backup_method=tar

```
and for remote:
```sh
docker exec -it CONTAINER_NAME ezbackup remote_backup_method=rsyncnet

```
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
The URL of your Discord webhook. This is where notifications will be sent.
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

