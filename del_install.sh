#!/bin/bash

# Download and install del from source repo
curl -o /usr/local/bin/del https://raw.githubusercontent.com/SathvikPN/del/main/del.sh \
  && chmod +x /usr/local/bin/del \
  && echo "del installed successfully."