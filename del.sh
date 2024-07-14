#!/bin/bash

# metadata
VERSION=1.0.0
AUTHOR=sathvikpn
# Configuration file
CONFIG_FILE="${HOME}/.delconfig"

# Default values
DEFAULT_TRASH_DIR="${HOME}/.local/share/Trash/files"
DEFAULT_AUTO_PURGE_DAYS=30
TRASH_DIR="$DEFAULT_TRASH_DIR"
AUTO_PURGE_DAYS="$DEFAULT_AUTO_PURGE_DAYS"
VERBOSE=0

# Cron job identifier
CRON_JOB_ID="del_cleanup"

# Function to create configuration file with default values
create_default_config() {
    cat <<EOF > "$CONFIG_FILE"
# Path to the trash directory
TRASH_DIR="${DEFAULT_TRASH_DIR}"

# Number of days after which files are permanently deleted
AUTO_PURGE_DAYS=${DEFAULT_AUTO_PURGE_DAYS}
EOF
}

# Function to load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        create_default_config
    fi
    source "$CONFIG_FILE"
}

# Function to show help
show_help() {
    echo "Usage: del [options] [file...]"
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -v, --version   Show version information"
    echo "  --config        Edit the configuration file"
    echo "  --verbose       Show verbose output"
    echo "  --cleanup       Perform cleanup of old files"
}

# Function to show version
show_version() {
    echo "del version $VERSION"
    echo "author: $AUTHOR"
}

# Function to ensure trash directory exists
ensure_trash_dir() {
    mkdir -p "$TRASH_DIR"
}

# Function to move file to trash
move_to_trash() {
    local src="$1"
    local filename=$(basename "$src")
    local dest="${TRASH_DIR}/${filename}"
    local metadata="${TRASH_DIR}/${filename}.delInfo"

    # Verbose output
    if [[ $VERBOSE -eq 1 ]]; then
        echo "Moving $src to $dest"
    fi

    # Move the file
    mv "$src" "$dest"

    # Create metadata file
    echo "deletedFrom: $(realpath "$src")" > "$metadata"
    echo "deletedOn: $(date '+%Y-%m-%d %H:%M:%S')" >> "$metadata"
}

# Function to cleanup old files
cleanup_old_files() {
    find "$TRASH_DIR" -type f -name "*.delInfo" -mtime +"$AUTO_PURGE_DAYS" -print0 | while IFS= read -r -d '' metadata; do
        local file="${metadata%.delInfo}"
        rm -f "$file" "$metadata"
        if [[ $VERBOSE -eq 1 ]]; then
            echo "deleted file: $file and metadata: $metadata"
        fi
    done
}

# Function to manage cron job for periodic cleanup
manage_cron_job() {
    local cron_cmd="0 0 ${AUTO_PURGE_DAYS} * * /usr/local/bin/del --cleanup # $CRON_JOB_ID"
    local cron_exists=$(crontab -l 2>/dev/null | grep -F "$CRON_JOB_ID")

    if [[ -z "$cron_exists" ]]; then
        # Cron job does not exist, create it
        (crontab -l 2>/dev/null; echo "$cron_cmd") | crontab -
        echo "Created cron job for periodic cleanup."
    else
        # Cron job exists, check if it needs updating
        local current_purge_days=$(echo "$cron_exists" | grep -oP 'mtime \+\K\d+')
        if [[ "$current_purge_days" != "$AUTO_PURGE_DAYS" ]]; then
            # Update the existing cron job
            crontab -l 2>/dev/null | grep -v "$CRON_JOB_ID" | { cat; echo "$cron_cmd"; } | crontab -
            echo "Updated cron job for periodic cleanup."
        fi
    fi
}

# Function to edit config file
edit_config() {
    ${EDITOR:-vi} "$CONFIG_FILE"
    # Reload configuration after editing
    load_config
    manage_cron_job
}

# Main script execution
load_config
ensure_trash_dir

case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        show_version
        exit 0
        ;;
    --config)
        edit_config
        exit 0
        ;;
    --verbose)
        VERBOSE=1
        shift
        ;;
    --cleanup)
        cleanup_old_files
        exit 0
        ;;
esac

if [[ $# -eq 0 ]]; then
    echo "Error: No files specified."
    show_help
    exit 1
fi

for file in "$@"; do
    if [[ -e "$file" ]]; then
        move_to_trash "$file"
    else
        echo "Error: File '$file' not found."
    fi
done

cleanup_old_files
manage_cron_job
