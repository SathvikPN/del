#!/bin/bash

VERSION=1.0.0
AUTHOR=sathvikpn
SOURCE='https://github.com/SathvikPN/del'

CRON_JOB_ID="del_cleanup"

# default configs 
VERBOSE=0
CONFIG_FILE="${HOME}/.delconfig"
DEFAULT_TRASH_DIR="${HOME}/.local/share/Trash/files"
DEFAULT_AUTO_PURGE_DAY=1
DEFAULT_KEEP_DAYS=7

create_default_config() {
cat <<EOF > "$CONFIG_FILE"
TRASH_DIR="${DEFAULT_TRASH_DIR}"

# keep deleted files in TRASH_DIR for these days
KEEP_DAYS=${DEFAULT_KEEP_DAYS}

# day of month [1-30]
AUTO_PURGE_DAY=${DEFAULT_AUTO_PURGE_DAY}

EOF
}

del_init(){
    if [[ ! -f "$CONFIG_FILE" ]]; then
        create_default_config
        source "$CONFIG_FILE"
        manage_auto_cleanup
    else 
        source "$CONFIG_FILE"
    fi

    mkdir -p $TRASH_DIR
}

show_help() {
cat << EOF
Usage: del [OPTIONS] FILE...

Options:
    -h, --help      Show this help message and exit
    -v, --verbose   Show the actions performed
        --version   Show version information
        --config    Update configuration file
        --reset     Reset config file to defaults
        --cleanup   Clear files older than configured days
EOF
}

# Function to show version
show_version() {
    echo "version: del $VERSION"
    echo " author: $AUTHOR"
    echo " source: $SOURCE"
}

edit_config() {
    ${EDITOR:-vi} "$CONFIG_FILE"
    # Reload configuration after editing
    source "$CONFIG_FILE"
    manage_auto_cleanup
    echo "del: set delete files older than [$KEEP_DAYS days]"
}

move_to_trash() {
    local src="$1"
    local filename=$(basename "$src")
    local dest="${TRASH_DIR}/${filename}"
    local metadata="${TRASH_DIR}/${filename}.delInfo"

    # Verbose output
    if [[ $VERBOSE -eq 1 ]]; then
        echo "trashing '$filename' to '$dest'"
    fi

    # Move the file
    mv "$src" "$dest"

    # Create metadata file
    echo "deletedFrom: $(realpath "$src")" > "$metadata"
    echo "deletedOn: $(date '+%Y-%m-%d %H:%M:%S')" >> "$metadata"
    echo "deletedBy: $USER" >> "$metadata"
}

# cleanup old files
cleanup_old_files() {
    find "$TRASH_DIR" -type f -name "*.delInfo" -mtime +"$KEEP_DAYS" -print0 | while IFS= read -r -d '' metadata; do
        local file="${metadata%.delInfo}"
        rm -f "$file" "$metadata"
        echo "del: deleted '$file' and metadata '$metadata'"
    done
}


# manage cron job for scheduled cleanup
manage_auto_cleanup() {
    local cron_cmd="0 0 ${AUTO_PURGE_DAY} * * /usr/local/bin/del --cleanup # $CRON_JOB_ID"
    local cron_exists=$(crontab -l 2>/dev/null | grep -F "$CRON_JOB_ID")

    if [[ -z "$cron_exists" ]]; then
        # Cron job does not exist, create it
        (crontab -l 2>/dev/null; echo "$cron_cmd") | crontab -
    else 
        crontab -l 2>/dev/null | grep -v "$CRON_JOB_ID" | { cat; echo "$cron_cmd"; } | crontab - 2>/dev/null
    fi

    if [ $? -eq 0 ]; then
        echo "del: schedule auto delete [day $AUTO_PURGE_DAY of every month]"
    else
        echo "del: AUTO_PURGE_DAY requires day of a month [1-30]"
        exit 1
    fi
}

del_reset() {
    rm -f $CONFIG_FILE
    del_init
    echo "del: set delete files older than [$KEEP_DAYS days]"
}



# script starts here ----------------------------------------------------------

del_init

# parse args
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--verbose)
        VERBOSE=1
        shift
        ;;
    --version)
        show_version
        exit 0
        ;;
    --config)
        edit_config
        exit 0
        ;;
    --reset)
        del_reset
        exit 0
        ;;
    --cleanup)
        cleanup_old_files
        exit 0
        ;;
esac

if [[ $# -eq 0 ]]; then
    echo "del: no files specified."
    show_help
    exit 1
fi

for file in "$@"; do
    if [[ -e "$file" ]]; then
        move_to_trash "$file"
    else
        echo "Error: not found '$file'"
    fi
done