# Use the official Alpine base image
FROM alpine:latest

# Set the working directory
WORKDIR /data/EZ_BACKUPS

# Install the tzdata package and set the timezone
RUN apk --no-cache add tzdata \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone
# Install necessary packages
RUN apk --no-cache add curl zip tar rsync bash openssh

# Copy the scripts to the container
COPY main.sh /data/EZ_BACKUPS/main.sh 
COPY adhoc_backup.sh /data/EZ_BACKUPS/adhoc_backup.sh
COPY modules/* /data/EZ_BACKUPS/modules/
COPY modules/alias.sh /usr/local/bin/ezbackups

RUN chmod +x /usr/local/bin/ezbackups
RUN chmod +x /data/EZ_BACKUPS/adhoc_backup.sh

# Make the script executable
RUN chmod +x /data/EZ_BACKUPS/modules/entrypoint.sh /data/EZ_BACKUPS/main.sh

# Create log file dir
RUN mkdir /data/logs

# Update the system timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the script as the entry point
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/data/EZ_BACKUPS/modules/entrypoint.sh"]