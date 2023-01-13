#!/bin/bash
# Put this script in /etc/NetworkManager/dispatcher.d/pre-up.d
# Ensure the script is owned by root and executable

if [ "$2" = "up" ]; then
  if ["$CONNECTION_UUID" = "e40fc7a7-0055-475c-85d7-9f630c1a5cfe" ]; then
    systemctl enable --now autofs.service
  fi
fi
