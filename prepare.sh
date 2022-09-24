#!/usr/bin/env bash

# Show contents of image
ls -l

# Install dependencies
sudo apt-get update
sudo apt-get install -y bzip2

# Create monero user
sudo adduser --disabled-password --gecos "" monero
chmod +x /monero-pi/update.sh && sudo cp /monero-pi/update.sh /home/monero/update.sh
chmod +x /monero-pi/monerod.conf && sudo cp /monero-pi/monerod.conf /home/monero/monerod.conf
chmod +x /monero-pi/monerod.service && sudo cp /monero-pi/monerod.service /home/monero/monerod.service
sudo chown monero:monero -R /home/monero

# Allow user services to linger
sudo loginctl enable-linger monero

# Change user
su monero
cd /home/monero

# Install monero client
/home/monero/update.sh

# Fix access to systemctl
echo "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus" >> ./.bashrc
. /home/monero/.bashrc

# Link service file 
mkdir -p /home/monero/.config/systemd/user
ln -s /home/monero/monerod.service /home/monero/.config/systemd/user/monerod.service

# Enable the monerod service and make sure it is stopped
systemctl --user enable monerod.service
systemctl --user stop monerod.service

# Clean apt-get cache
rm -rf /var/lib/apt/lists/*
