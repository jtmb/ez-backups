#!/bin/bash
# Main script

# imports
source modules/backup_modules.sh
source modules/messaging_modules.sh
source modules/vars.sh

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

    echo "Current time: $current_hour:$current_minute"
    echo "Scheduled backup time: $scheduled_hour:$scheduled_minute"
    echo "Time until next backup: $time_until_backup minutes"

    # Check if it's time for backup
    if [ "$time_until_backup" -le 0 ]; then
        # Perform local backup
        local_backup
        backup_status=$?

        if [ "$backup_status" -eq 0 ]; then
            # Backup was successful, sleep for one hour
            # Send Discord message
            discord_message
            echo "Sleeping for one hour..."
            sleep 3600  # Sleep for one hour (3600 seconds)
        fi

    fi

    # Sleep for a short duration (e.g., 30 seconds) before checking again
    sleep 30
done
