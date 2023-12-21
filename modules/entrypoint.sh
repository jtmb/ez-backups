#!/bin/bash

# Set logs and Run application (sed -r) exits  the special characters in the stdout so you can get clean logs 
                        #  (tee) pushes the logs to specified log file while still maintaining output in terminal
/data/EZ_BACKUPS/main.sh > >(tee >(sed -r "s/\x1B\[[0-9;]*[JKmsu]//g" > /data/logs/ez_backups.log))