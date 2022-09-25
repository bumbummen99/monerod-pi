# Monerod Pi
A simple to install ubuntu server image for running a monero full node on raspberry pi. Become a part of the monero network and never wait for your blockchain to sync again when you want to make transactions by using your raspberry pi as your own local remote node.

# Recommendations
- Use an external drive to prevent SD card wear out (SSD recommended)
- Use swap space with Pi 3B to prevent OOM during initial sync
- Sync initial blockchain on another computer and export it (or download the .raw from the [offical site](https://www.getmonero.org/downloads/#blockchain) on your own risk)

# Setup
1) Simply download and write the image to your SD card using etcher or similar software.
2) Boot up the system and ssh into it (password is `ubuntu`)
   ```
   ssh ubuntu@IP-OF-YOUR-PI
   ```
3) Change to the monero user and change directory to home
   ```
   su monero && cd ~
   ```
4) Edit the [monerod.conf](https://monerodocs.org/interacting/monero-config-file/) to your needs
   ```
   nano monerod.conf
   ```
5) If you use an external drive, make sure to mount it via `/etc/fstab`
   ```
   /dev/sda1 /external ext4 defaults 0 1
   ```
6) Enable and start the monerod service using the following commands
   ```
   systemctl --user enable monerod.service
   systemctl --user start monerod.service
   ```
   
# RAM
(Older) Raspberry Pi's are not known for their plentiful RAM, therefore it is necessary to create a swap file to prevent an OOM and crash during the initial sync. A fully synced node can easily run with the 1GB of ram. To add swap space simply use the following commands:
```
sudo sysctl vm.swappiness=1
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```
