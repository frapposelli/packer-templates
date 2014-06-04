# Settings to ensure that ESXi cloning goes smooth, thanks @lamw ! see:
# http://www.virtuallyghetto.com/2013/12/how-to-properly-clone-nested-esxi-vm.html
esxcli system settings advanced set -o /Net/FollowHardwareMac -i 1
sed -i '/\/system\/uuid/d' /etc/vmware/esx.conf

# DHCP doesn't refresh correctly upon boot, this will force a renew, it will
# be executed on every boot, if you don't like this behavior you can remove
# the line during the Vagrant provisioning part.
sed -i '/exit 0/d' /etc/rc.local.d/local.sh 
echo 'esxcli network ip interface set -e false -i vmk0; esxcli network ip interface set -e true -i vmk0' >> /etc/rc.local.d/local.sh 
echo 'exit 0' >> /etc/rc.local.d/local.sh 

# Ensure changes are persistent
/sbin/auto-backup.sh
