#!/usr/bin/env bash

# Show contents of image
ls -l

# Install dependencies
sudo apt-get update
sudo apt-get install -y bzip2

# Create monero user
sudo adduser --disabled-password --gecos "" monero
chmod +x /monerod-pi/update.sh && sudo cp /monerod-pi/update.sh /home/monero/update.sh
chmod +x /monerod-pi/monerod.conf && sudo cp /monerod-pi/monerod.conf /home/monero/monerod.conf
chmod +x /monerod-pi/monerod.service && sudo cp /monerod-pi/monerod.service /home/monero/monerod.service
sudo chown monero:monero -R /home/monero

# Allow user services to linger
sudo loginctl enable-linger monero

# Change user
su monero
cd /home/monero

# Install monero client
/home/monero/update.sh

# Fix access to systemctl
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" >> ./.bashrc
. /home/monero/.bashrc

# Link service file 
mkdir -p /home/monero/.config/systemd/user
ln -s /home/monero/monerod.service /home/monero/.config/systemd/user/monerod.service

# Clean apt-get cache
rm -rf /var/lib/apt/lists/*
