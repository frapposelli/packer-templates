packer-templates
================

These are the Packer templates for boxes available at https://vagrantcloud.com/gosddc, they only work with VMware and require the [packer-post-processor-vagrant-vmware-ovf](https://github.com/gosddc/packer-post-processor-vagrant-vmware-ovf) post-processor to work.

These templates will output a Vagrant box for each OS version in the new universal format [vmware_ovf](https://github.com/gosddc/packer-post-processor-vagrant-vmware-ovf/wiki/vmware_ovf-Box-Format).

The templates will take care of installing the Operating system from the ISO, install VMware tools, install the Puppet agent and perform a ```puppet-masterless``` configuration for [Vagrant](http://vagrantup.com). It can be easily expanded by adding more puppet modules.