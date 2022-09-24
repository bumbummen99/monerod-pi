#!/usr/bin/env bash

# Show contents of image
ls -l

# Install dependencies
sudo apt-get update
sudo apt-get install -y bzip2

# Create monero user
sudo adduser --disabled-password --gecos "" monero

# Own pre-occupied home
sudo chown monero:monero -R /home/monero

# Allow user services to linger
sudo loginctl enable-linger monero

# Change user
su monero && . /home/monero/.bashrc && cd ~

# Install monero client
$HOME/update.sh

# Fix access to systemctl
echo "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus" >> $HOME/.bashrc

# Link service file 
mkdir -p $HOME/.config/systemd/user
ln -s monerod.service $HOME/.config/systemd/user/monerod.service

# Enable the monerod service and make sure it is stopped
systemctl --user enable monerod.service
systemctl --user stop monerod.service

# Clean apt-get cache
rm -rf /var/lib/apt/lists/*
