#!/bin/bash

VERSION=1.0.0
AUTHOR=sathvikpn
SOURCE='https://github.com/SathvikPN/del'

# default configs 
VERBOSE=0
CONFIG_FILE="${HOME}/.delconfig"
DEFAULT_TRASH_DIR="${HOME}/.local/share/Trash/files"
DEFAULT_AUTO_PURGE_DAYS=30
CRON_JOB_ID="del_cleanup"

create_default_config() {
cat <<EOF > "$CONFIG_FILE"
TRASH_DIR="${DEFAULT_TRASH_DIR}"
AUTO_PURGE_DAYS=${DEFAULT_AUTO_PURGE_DAYS}
EOF
}

del_init(){
    if [[ ! -f "$CONFIG_FILE" ]]; then
        create_default_config
    fi
    source "$CONFIG_FILE"
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