#!/bin/bash

# Function to perform local backup
remote_backup() {
    echo "Performing local backup..."

    # Check if local_backup_method is defined
    if [ -z "$remote_backup_method" ]; then
        echo "Remote backup method is not defined. Skipping backup."
        return
    fi

    # Convert the source_dir string to an array
    source_dirs=($source_dir)

    # Iterate over source directories and perform rsync or zip for each
    for dir in "${source_dirs[@]}"; do
        # Get the basename of the source directory
        source_basename=$(basename "$dir")

        # Perform rsync or tar/zip based on the selected method
        case "$remote_backup_method" in
            rsync)
                chmod 600 /.ssh/$private_key_name
                rsync -avz -e "ssh -o StrictHostKeyChecking=no -i /.ssh/$private_key_name" "$dir" "$remote_user@$remote_host:$backup_destination"
                ;;
            *)
                echo "Unknown local backup method: $remote_backup_method"
                ;;
        esac
    done
}


# Function to perform local backup
local_backup() {
    echo "Performing local backup..."

    # Check if local_backup_method is defined
    if [ -z "$local_backup_method" ]; then
        echo "Local backup method is not defined. Skipping backup."
        return
    fi

    # Convert the source_dir string to an array
    source_dirs=($source_dir)

    # Iterate over source directories and perform rsync or zip for each
    for dir in "${source_dirs[@]}"; do
        # Get the basename of the source directory
        source_basename=$(basename "$dir")

        # Create the destination path by appending the source_basename
        mkdir -p "$backup_destination/$(date +"%Y-%m-%d")"
        destination_local="$backup_destination/$(date +"%Y-%m-%d")/$source_basename"

        # Perform rsync or tar/zip based on the selected method
        case "$local_backup_method" in
            rsync)
                rsync -avz "$dir" "$destination_local"
                ;;
            tar)
                tar -cvzf "$destination_local.tgz" "$dir"
                ;;
            zip)
                zip -r "$destination_local.zip" "$dir"
                ;;
            *)
                echo "Unknown local backup method: $local_backup_method"
                ;;
        esac
    done
}
