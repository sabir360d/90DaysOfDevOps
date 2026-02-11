#!/bin/bash

# Exit if not run as root
if [ "$EUID" -ne 0 ]
then
    echo "Please run this script as root."
    exit 1
fi

packages="nginx curl wget"

for pkg in $packages
do
    if dpkg -s "$pkg" &> /dev/null
    then
        echo "$pkg is already installed. Skipping."
    else
        echo "$pkg is not installed. Installing..."
        apt update -y
        apt install -y "$pkg"
        echo "$pkg installation complete."
    fi
done

