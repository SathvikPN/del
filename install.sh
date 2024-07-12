#!/bin/bash

# Installation directory
INSTALL_DIR="/usr/local/bin"
CONFIG_FILE="$HOME/.delconfig"

# Clone the repository
git clone https://github.com/SathvikPN/del.git /tmp/del

# Move the main script to the installation directory
sudo mv /tmp/del/del.sh "$INSTALL_DIR/del"
sudo chmod +x "$INSTALL_DIR/del"

# Move the auto purge script to the installation directory
sudo mv /tmp/del/purge.sh "$INSTALL_DIR/purge"
sudo chmod +x "$INSTALL_DIR/purge"

# Copy the example configuration file to the user's home directory if not present
if [ ! -f "$CONFIG_FILE" ]; then
  cp /tmp/del/.delconfig "$CONFIG_FILE"
fi

# Set up the cron job for automatic purging
(crontab -l 2>/dev/null; echo "0 20 */$AUTO_PURGE_DAYS * * $INSTALL_DIR/purge") | crontab -


# Clean up
rm -rf /tmp/del

echo "Installation completed. You can now use 'del' command."
