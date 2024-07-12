#!/bin/bash

TRASH_DIR="$HOME/.trash_directory"
AUTO_PURGE_DAYS=7
LAST_RUN_FILE="$HOME/.last_purge_date"

# Function to check if it's time to purge
should_purge() {
  if [[ ! -f "$LAST_RUN_FILE" ]]; then
    return 0  # No last run date file, so we should purge
  fi

  last_run=$(cat "$LAST_RUN_FILE")
  now=$(date +%s)
  days_diff=$(( (now - last_run) / 86400 ))

  if (( days_diff >= AUTO_PURGE_DAYS )); then
    return 0  # Time to purge
  else
    return 1  # Not yet time to purge
  fi
}

# Function to perform the purge
purge() {
  find "$TRASH_DIR" -type f -mtime +"$AUTO_PURGE_DAYS" -delete
  echo $(date +%s) > "$LAST_RUN_FILE"
}

# Main script execution
if should_purge; then
  purge
fi
