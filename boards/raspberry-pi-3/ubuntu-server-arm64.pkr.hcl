source "arm" "ubuntu" {
  file_urls = ["https://cdimage.ubuntu.com/releases/22.04.1/release/ubuntu-22.04.1-preinstalled-server-arm64+raspi.img.xz"]
  file_checksum_url = "http://cdimage.ubuntu.com/releases/22.04.1/release/SHA256SUMS"
  file_checksum_type = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_build_method = "reuse"
  image_path = "ubuntu-22.04.1.img"
  image_size = "3.1G"
  image_type = "dos"
  image_partitions {
    name = "boot"
    type = "c"
    start_sector = "2048"
    filesystem = "fat"
    size = "256M"
    mountpoint = "/boot/firmware"
  }
  image_partitions {
    name = "root"
    type = "83"
    start_sector = "526336"
    filesystem = "ext4"
    size = "2.8G"
    mountpoint = "/"
  }
  image_chroot_env = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  qemu_binary_source_path = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
}

build {
  sources = ["source.arm.ubuntu"]
  
  provisioner "shell" {
    inline = [
      "mv /etc/resolv.conf /etc/resolv.conf.bk",                                                   # Backup resolv.conf
      "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf",                                             # Add google dns as fallback nameserver for apt-get
      "sudo apt-get update && sudo apt-get install -y bzip2",                                      # Install dependencies
      "mv /etc/resolv.conf.bk /etc/resolv.conf",                                                   # Restore resolv.conf
      "sudo adduser --disabled-password --gecos \"\" monero",                                      # Create user to run the monero node
      "mkdir -p /var/lib/systemd/linger",                                                          # Enable user services to run on boot
      "chmod 755 /var/lib/systemd/linger",
      "sudo touch /var/lib/systemd/linger/monero",
      "chmod 644 /var/lib/systemd/linger/monero",                                                  
      "su monero",                                                                                 # Change user to monero
      "mkdir -p /home/monero/.config/systemd/user",                                                # Create the users services directory
      "echo \"DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus\" >> /home/monero/.bashrc" # Fix access to systemctl --user
    ]
  }
  
  # Add handy scripts, configuration and service to the user
  provisioner "file" {
    sources = ["update.sh", "monerod.conf", "monerod.service"]
    destination = "/home/monero"
  }
  
  provisioner "shell" {
    inline = [
      "sudo chown monero:monero -R /home/monero",                                                                                        # Fix ownership of added files
      "su monero",                                                                                                                       # Change user to monero
      "chmod +x /home/monero/update.sh",                                                                                                 # Make update.sh executable
      "ln -s /home/monero/monerod.service /home/monero/.config/systemd/user/monerod.service",                                            # Link the systemd service file to the users services directory
      "(crontab -l 2>/dev/null; echo \"0 0 * * * /home/monero/update.sh && /bin/systemctl --user restart monerod.service\") | crontab -" # Add crontab to keep monero node up to date
    ]
  }
}
