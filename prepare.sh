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
mkdir -p /var/lib/systemd/linger
chmod 755 /var/lib/systemd/linger
sudo touch /var/lib/systemd/linger/monero
chmod 644 /var/lib/systemd/linger/monero

# Change user
su monero
cd /home/monero

# Install monero client
/home/monero/update.sh

# Fix access to systemctl
echo "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus" >> /home/monero/.bashrc

# Link service file 
mkdir -p /home/monero/.config/systemd/user
ln -s /home/monero/monerod.service /home/monero/.config/systemd/user/monerod.service

# Add crontab entry for update
echo "0 0 * * * /home/monero/update.sh && /bin/systemctl --user restart monerod.service" >> /var/spool/cron/crontabs/monero
chown monero:monero /var/spool/cron/crontabs/monero
chmod 600 /var/spool/cron/crontabs/monero

ls -l /var/spool/cron/crontabs

# Clean apt-get cache
rm -rf /var/lib/apt/lists/*
