# Monerod Pi
A simple Ubuntu server imnage for raspberry pi with monero full node installed and ready.

# Setup
1) Simply download and write the image to your SD card using etcher or similar software.
2) Boot up the system and ssh into it (password is ubuntu)
   ```
   ssh ubuntu@IP-OF-YOUR-PI
   ```
3) Change to the monero user and change directory to home
   ```
   su monero && cd ~
   ```
4) Edit the monerod.conf to your needs
   ```
   nano monerod.conf
   ```
5) If you use an external drive, make sure to mount it via /etc/fstab
   ```
   /dev/sda1 /external ext4 defaults 0 1
   ```
6) Enable and start the monerod service using the following commands
   ```
   systemctl --user enable monerod.service
   systemctl --user start monerod.service
   ```
   
# RAM
(Older) Raspberry Pi's are not known for their plentiful RAM, therefore it is necessary to create a swap file to prevent an OOM and crash. To do so simply use the following commands:
```
sysctl vm.swappiness=1
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```
