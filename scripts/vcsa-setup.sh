#!/bin/bash

set -e


# Add vagrant user & vagrant ssh keys
/usr/sbin/groupadd vagrant
/usr/sbin/useradd vagrant -g vagrant -G wheel -s /bin/bash
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate \
    'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' \
    -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant


# VMware configures sshd MaxSessions at 1 where the default is 10. this
# breaks vagrant. remove the VMware configuration and set back to default
# configuration. See: https://github.com/mitchellh/vagrant/issues/4044
sed -i '/MaxSessions.*$/d' /etc/ssh/sshd_config


# Install vmware HGFS driver for shared folders or else vagrant will complain
zypper addrepo --refresh --no-gpgcheck \
    http://packages.vmware.com/tools/esx/5.5u1/sles11.2/x86_64/ vmware-tools
zypper install -y vmware-tools-esx-nox vmware-tools-hgfs


# Remove traces of mac address from network configuration
rm -rfv /etc/udev/rules.d/70-persistent-net.rules \
        /lib/udev/rules.d/75-persistent-net-generator.rules


# From http://www.virtuallyghetto.com/2012/02/automating-vcenter-server-appliance.html
echo "Performing initial vCenter configuration"
echo "This will take several minutes ..."
/usr/sbin/vpxd_servicecfg eula accept
/usr/sbin/vpxd_servicecfg timesync write tools
/usr/sbin/vpxd_servicecfg db write embedded
/usr/sbin/vpxd_servicecfg sso write embedded
/usr/sbin/vpxd_servicecfg service start

# From http://www.virtuallyghetto.com/2013/04/automating-ssl-certificate-regeneration.html
# Needed otherwise vagrant's changing of the VM's hostname will
# break SSL certs.
echo only-once > /etc/vmware-vpx/ssl/allow_regeneration

echo "Done"

