#!/bin/bash

# Check if script is run as root
if [ "$UID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Variables
REPO_URL="https://github.com/SmugZombie/DeckShare/archive/refs/heads/main.zip"
TEMP_DIR="/opt/DeckShare-main"
INSTALL_DIR="/opt/DeckShare"
SERVICE_NAME="deckshare"

# Download the repository
wget -O main.zip $REPO_URL

# Unzip the repository
unzip main.zip -d /opt/

mv $TEMP_DIR $INSTALL_DIR

# Change to the install directory
cd $INSTALL_DIR

# Run the install commands
cp ./deckshare.service /etc/systemd/system/

# Enable the service:
systemctl enable deckshare.service

#Start the service:
systemctl start deckshare.service
