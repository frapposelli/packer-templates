#!/bin/bash

sudo mkdir /media/cdrom 
sudo mount -o loop /home/vagrant/linux.iso /media/cdrom
sudo cp /media/cdrom/VMwareTools*.tar.gz /home/vagrant
tar xfz VMwareTools*.tar.gz
cd /home/vagrant/vmware-tools-distrib
sudo ./vmware-install.pl -d
sudo umount /media/cdrom
cd /home/vagrant
rm -rf vmware-tools-distrib
rm -f VMwareTools*.tar.gz
rm linux.iso
