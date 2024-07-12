#!/bin/bash

DEL_VERSION='0.0.1'
TRASH_DIR="$HOME/.trash_directory"
VERBOSE=false

if [ $# -eq 0 ]; then
  echo "Welcome to 'del'
  - a trashing utility for your linux bash terminal
  "
  exit 0
fi

show_help() {
  cat << EOF
  Usage: del [OPTIONS] FILE...

  Move FILE(s) to a recycle bin directory.

  Options:
    -h, --help      Show this help message and exit
    -v, --verbose   Show detailed information of actions performed
    -p, --purge     Permanently delete files in trash-directory
    --version       Show version information
EOF
}

show_version() {
  echo "del version $DEL_VERSION"
}

move_to_trash() {
  local file=$1
  if [ -e $file ]; then 
    local dest="$TRASH_DIR/$(basename "$file")_$(date +%s)"
    mv "$file" "$dest"
    [ "$VERBOSE" == true ] && echo "trashed $file to $dest"
  else
    echo "file not found: $file"
  fi
}

purge_files() {
  rm -rf $TRASH_DIR/*
  [ "$VERBOSE" == true ] && echo "Permanently deleted files from $TRASH_DIR"
}

main() {
  # parse command-line options -------------------------------------------------------
  # =~ bash pattern matching operator, true if $1 matches ^-(string that starts with -)
  while [[ "$1" =~ ^- ]]; do 
    case $1 in
      -h | --help)
        show_help
        exit 0
        ;; # ends case
      -v | --verbose)
        VERBOSE=true
        ;;
      -p | --purge)
        purge_files
        ;;
      --version)
        echo "del version 0.0.0"  # Assuming the next argument is the author's name
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
    shift  # Move to the next argument $1 <-- $2 (now $1 points to 2nd positional arg)
  done  

  mkdir -p $TRASH_DIR # create trash_dir if not exist

  for file in "$@"; do 
    move_to_trash "$file"
  done 
}

main "$@"