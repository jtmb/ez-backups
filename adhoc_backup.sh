#!/bin/bash

# imports
source modules/backup_modules.sh

# Initialize variables
local_backup_method=""
remote_backup_method=""

# Parse arguments
for arg in "$@"; do
    case $arg in
        local_backup_method=*)
            local_backup_method="${arg#*=}"
            ;;
        remote_backup_method=*)
            remote_backup_method="${arg#*=}"
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

# Define color variables (you can adjust or add colors as needed)
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# Check and call the appropriate function
if [ -n "$remote_backup_method" ]; then
    # Check if remote_backup function is defined
    if declare -f remote_backup > /dev/null; then
        echo "Calling remote_backup function..."
        remote_backup
        if [ $? -eq 0 ]; then
            echo -e "${YELLOW}Remote Backup${RESET} ${GREEN}Complete ✅${RESET}"
        else
            echo -e "${YELLOW}Remote Backup${RESET} ${RED}Failed ❌${RESET}"
            exit 1
        fi
    else
        echo "remote_backup function is not defined."
        exit 1
    fi
elif [ -n "$local_backup_method" ]; then
    # Check if local_backup function is defined
    if declare -f local_backup > /dev/null; then
        echo "Calling local_backup function..."
        local_backup
        if [ $? -eq 0 ]; then
            echo -e "${YELLOW}Local Backup${RESET} ${GREEN}Complete ✅${RESET}"
        else
            echo -e "${YELLOW}Local Backup${RESET} ${RED}Failed ❌${RESET}"
            exit 1
        fi
    else
        echo "local_backup function is not defined."
        exit 1
    fi
else
    echo "No valid backup method provided. Please specify either 'local_backup_method' or 'remote_backup_method'."
    echo "local_backup_method options: rsync tar zip"
    echo "remote_backup_method options: rsyncnet"
    exit 1
fi
