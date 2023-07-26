#!/bin/bash
echo "*** Running script $0"
echo "*** The interface is $1 in state $2"
echo "*** The CONNECTION ID is $CONNECTION_ID, and the CONNECTION UUID is $CONNECTION_UUID"
if [ "$2" == "pre-up" ]; then
  echo "*** We have determined that the connection is in state $2"
  #if [ "$CONNECTION_UUID" == "2911db45-3eff-3b74-9c87-4c36e0290693" ]; then
  #if [ "$CONNECTION_ID" = "eraser215" ]; then
  if [ "$CONNECTION_ID" == "eraser215" ] || [ "$CONNECTION_ID" == "Wired connection 1" ]; then
    echo "*** Enabling autofs"
    systemctl enable --now autofs.service
  fi
fi
