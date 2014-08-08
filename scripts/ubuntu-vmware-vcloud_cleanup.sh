#!/bin/bash -eux
# Blatantly stolen from from https://raw.githubusercontent.com/StefanScherer/ubuntu-vm/my/script/cleanup-vcloud.sh
# Thanks Stefan!

CLEANUP_PAUSE=${CLEANUP_PAUSE:-0}
echo "==> Pausing for ${CLEANUP_PAUSE} seconds..."
sleep ${CLEANUP_PAUSE}

# Make sure udev does not block our network - http://6.ptmc.org/?p=164
echo "==> Cleaning up udev rules"
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "==> Cleaning up leftover dhcp leases"
# Ubuntu 10.04
if [ -d "/var/lib/dhcp3" ]; then
    rm /var/lib/dhcp3/*
fi
# Ubuntu 12.04 & 14.04
if [ -d "/var/lib/dhcp" ]; then
    rm /var/lib/dhcp/*
fi 

if [ ! -d "/etc/dhcp3" ]; then
  if [ -d "/etc/dhcp" ]; then
    echo "Patching /etc/dhcp3 for vCloud"
    ln -s /etc/dhcp /etc/dhcp3
  fi
fi

echo "Writing a fixed eth0 entry to avoid delay on first boot in vCloud"
cat <<CFG | tee /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
  address 192.168.66.111
        netmask 255.255.255.0
        gateway 192.168.66.1
        metric 0
CFG

echo "==> Removing network-manager (KB2042181)"
apt-get remove --purge network-manager

echo "==> Cleaning up tmp"
rm -rf /tmp/*

# Cleanup apt cache
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

echo "==> Installed packages"
dpkg --get-selections | grep -v deinstall

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Clean up log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm /boot/whitespace

# Zero out the free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early before the large files are deleted
sync