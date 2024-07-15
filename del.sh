#!/bin/bash

VERSION=1.0.0
AUTHOR=sathvikpn

# default configs
VERBOSE=0

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
    echo "del version $VERSION"
    echo "author: $AUTHOR"
}

# script starts here ----------------------------------------------------------

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
        exit 0
        ;;
esac

if [[ $# -eq 0 ]]; then
    echo "del: no files specified."
    show_help
    exit 1
fi