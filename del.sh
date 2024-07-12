#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Welcome to 'del'
  - a trashing utility for your linux bash terminal"
  exit 0
fi

# Function to display help
show_help() {
  cat << EOF
Usage: del [OPTIONS] FILE...

Move FILE(s) or directories to a recycle bin directory.

Options:
  -h, --help      Show this help message and exit
  -v, --verbose   Show detailed information of actions performed
  --version       Show version information
  --purge         Permanently delete files in trash-directory ($TRASH_DIR)
EOF
}

# parse command-line options
# =~ bash pattern matching operator, true if $1 matches ^-(string that starts with -)
while [[ "$1" =~ ^- ]]; do 
  case $1 in
    -h | --help)
      show_help
      exit 0
      ;; # ends case
    -v | --verbose)
      echo "option for verbose output"
      ;;
    --version)
      echo "del version 0.0.0"  # Assuming the next argument is the author's name
      shift  # Move past the argument value
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift  # Move to the next argument $1 <-- $2 (now $1 points to 2nd positional arg)
done