#!/bin/bash

CONFIG_FILE=".delconfig"
# Load configuration if it exists
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi

auto_purge_files() {
    # List files older than AUTO_PURGE_DAYS
    old_files=$(find "$TRASH_DIR" -type f -mtime +"$AUTO_PURGE_DAYS")

    if [[ -z "$old_files" ]]; then
        echo "No files older than $AUTO_PURGE_DAYS days in $TRASH_DIR."
    else
        echo "The following files are older than $AUTO_PURGE_DAYS days in $TRASH_DIR:"
        echo "$old_files"
        
        read -p "Do you want to delete these files? (y/n): " choice
        case "$choice" in
            y|Y )
                echo "Deleting files..."
                find "$TRASH_DIR" -type f -mtime +"$AUTO_PURGE_DAYS" -delete
                echo "Files deleted."
                ;;
            n|N )
                echo "Skipping deletion."
                ;;
            * )
                echo "Invalid input. Skipping deletion."
                ;;
        esac
    fi
}

auto_purge_files "$@"