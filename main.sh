# Function to echo shutdown message in red
shutdown_message() {
    echo -e "${YELLOW}Ez Backups${RESET} is ${RED}OFFLINE ❌${RESET}"
}

# Trap the termination signal and execute the shutdown message function
trap 'shutdown_message' EXIT

# imports
source modules/backup_modules.sh
source modules/messaging_modules.sh
source modules/vars.sh
source modules/banner.sh

backup_in_progress=0  # Flag to track if backup is in progress
backup_checked=0      # Flag to track if time until next backup has been checked

while true; do
    # Get the current hour and minute in 24-hour format
    current_hour=$(date +"%-H")  # Use %-H to remove leading zero
    current_minute=$(date +"%-M")  # Use %-M to remove leading zero

    # Calculate time until the next backup in minutes
    time_until_backup=$(( (scheduled_hour - current_hour) * 60 + (scheduled_minute - current_minute) ))

    if [ "$time_until_backup" -lt 0 ]; then
        # Adjust for the next day
        time_until_backup=$((time_until_backup + 24 * 60))
    fi

    if [ "$backup_in_progress" -eq 0 ]; then
        if [ "$backup_checked" -eq 0 ]; then
            echo
            echo "Current time: $current_hour:$current_minute"
            echo "Scheduled backup time: $scheduled_hour:$scheduled_minute"
            echo "Time until next backup: $time_until_backup minutes"
            backup_checked=1
        fi
    else
        backup_checked=0  # Reset the flag when backup is in progress
    fi

    # Check if it's time for backup and backup is not in progress
    if [ "$time_until_backup" -le 0 ] && [ "$backup_in_progress" -eq 0 ]; then
        # Set flag to indicate backup is in progress
        backup_in_progress=1

        # Perform local backup
        remote_backup
        local_backup
        backup_status=$?

        if [ "$backup_status" -eq 0 ]; then
            # Backup was successful, reset flags and sleep for one hour
            backup_in_progress=0
            backup_checked=0
            # Send Discord message
            discord_message
            echo -e "${WHITE}$source_dir_string${RESET} ${YELLOW}$backup_destination${RESET} ${GREEN}synced${RESET}"
            echo "Sleeping for one hour..."
            sleep 3600  # Sleep for one hour (3600 seconds)
        else
            # Backup failed, reset flag and continue checking
            backup_in_progress=0
            backup_checked=0
        fi
    fi

    # Sleep for a short duration (e.g., 30 seconds) before checking again
    sleep 30
done