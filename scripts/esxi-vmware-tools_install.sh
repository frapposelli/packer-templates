# Install VMware Tools for Nested ESXi, directly from VMware website, make
# sure you have internet connection available or change the URL to a local
# one.
esxcli network firewall ruleset set -e true -r httpClient
esxcli software vib install -v http://download3.vmware.com/software/vmw-tools/esxi_tools_for_guests/esx-tools-for-esxi-9.7.0-0.0.00000.i386.vib -f