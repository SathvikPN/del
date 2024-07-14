#!/bin/bash

# Download del.sh from GitHub
curl -o /usr/local/bin/del https://raw.githubusercontent.com/yourusername/del-utility/main/del.sh

# Make the script executable
chmod +x /usr/local/bin/del

echo "del installed successfully."

