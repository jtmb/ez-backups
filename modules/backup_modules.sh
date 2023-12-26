#!/bin/bash

# Function to perform local backup
local_backup() {
    echo "Performing local backup..."

    # Convert the source_dir string to an array
    source_dirs=($source_dir)

    # Iterate over source directories and perform rsync or zip for each
    for dir in "${source_dirs[@]}"; do
        # Get the basename of the source directory
        source_basename=$(basename "$dir")

        # Create the destination path by appending the source_basename
        mkdir $backup_destination $backup_destination/$(date +"%Y-%m-%d")
        destination_local="$backup_destination/$(date +"%Y-%m-%d")/$source_basename"

        # Perform rsync or zip based on the selected method
        if [ "$local_backup_method" = "rsync" ]; then
            rsync -avz "$dir" "$destination_local"
        fi
        if [ "$local_backup_method" = "tar" ]; then
            tar -cvzf $destination_local.tgz $dir
        fi
        if [ "$local_backup_method" = "zip" ]; then
            zip -r "$destination_local.zip" "$dir"
        fi
    done
}
