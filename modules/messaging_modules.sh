#!/bin/bash
source modules/vars.sh
# Construct the Discord embed message
discord_message() {
    source_dir_string=""
    # Iterate over array elements and concatenate into a string
        for dir in "${source_dir[@]}"; do
            source_dir_string+=" $dir"
        done
    # Remove leading space
    source_dir_string=${source_dir_string:1}
    echo "Source Directory String: $source_dir_string"

    EMBED_MESSAGE='{
        "embeds": [{
            "title": "EZ Backups: Service Status Update",
            "description": "💯✅ Backups Succesful !",
            "color": 65280,
            "fields": [
                {
                    "name": "Backup Source",
                    "value": "'$source_dir_string'"
                },
                {
                    "name": "Backup Destination",
                    "value": "'$backup_destination'"
                },
                {
                    "name": "Backup Method",
                    "value": "'$local_backup_method'"
                },
                {
                    "name": "Time (America/Toronto)",
                    "value": "'$(date +"%Y-%m-%d %H:%M:%S")'"
                }
            ],
            "footer": {
                "text": "'"$repo_url"'"
            }
        }]
    }'

    # Execute curl and capture the return status
    response=$(curl -s -H "Content-Type: application/json" -X POST -d "$EMBED_MESSAGE" "$WEBHOOK_URL")
    status=$?

    # Check the return status and print response for debugging
    if [ $status -eq 0 ]; then
        echo "Discord message sent successfully."
    else
        echo "Error sending Discord message. Status code: $status"
        echo "Response: $response"
    fi
}
