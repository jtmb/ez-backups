#!/bin/bash
# VARS

repo_url='https://github.com/jtmb/EZ_backups'
source_dir=("/test/test1" "/test/test2" "/test/test3")
backup_destination=test/
# local_backup_method=rsync_remote
# remote_backup_method=rsync
# scheduled_hour="20"
# scheduled_minute="34"
# WEBHOOK_URL=''
# private_key_name="id_rsa_rsyncNet"
# remote_host="host.rsync.net"
# remote_user="host_name"

# Define colors and formatting codes
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
BOLD="\033[1m"
WHITE="\033[1;37m"
YELLOW="\033[38;5;220m"
RESET="\033[0m"