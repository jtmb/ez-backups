#!/bin/bash
# VARS

repo_url='https://github.com/jtmb/EZ_backups'
source_dir=("/test/test1" "/test/test2" "/test/test3")
backup_destination=test/
# local_backup_method=rsync_remote
remote_backup_method=rsync
scheduled_hour="20"
scheduled_minute="34"
WEBHOOK_URL='https://discord.com/api/webhooks/1215676224895193108/ti6ye2M3e0KbrE1Zqs5Nhvn726pWe-iPpPewdTrDYc5WT3c01UnJqPaO74QDnaObgvvr'
private_key_name="id_rsa_rsyncNet"
remote_host="fm1897.rsync.net"
remote_user="fm1897"

# Define colors and formatting codes
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
BOLD="\033[1m"
WHITE="\033[1;37m"
YELLOW="\033[38;5;220m"
RESET="\033[0m"