#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status of $SERVICE? (y/n): " ANSWER

if [ "$ANSWER" = "y" ]; then
  systemctl is-active --quiet $SERVICE

  if [ $? -eq 0 ]; then
    echo "$SERVICE is running"
  else
    echo "$SERVICE is not running"
  fi
else
  echo "Skipped."
fi

