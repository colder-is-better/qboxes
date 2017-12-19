This is an alphabetical list of the currently implemented `qboxes` commands. Following each command is a short description of the functionality/features we plan on adding to it.

`activate`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)

`annihilate`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)
* remove entries from .ssh/known_hosts
* delete DHCP leases of annihilated domains (see files in `/var/lib/libvirt/dnsmasq`)

`attach`
* sanitize user input (volume/pool/VM names, volume capacity) (__DONE__)
* improve the matching of pool/VM names with dashes (__DONE__)
* automatically pick the first available block device name (`vdb`, `vdc`, etc) for new volumes

`check-service`
* sanitize user input (TCP port number, VM name) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)
* support checking of multiple VMs (__DONE__)

`clone`
* sanitize user input (pool/VM names) (__DONE__)
* improve the matching of pool/VM names with dashes (__DONE__)
* delete SSH host keys in clones (__DONE__)
* handle the cloning of "empty" VMs
* clone VMs with more than one storage volumes

`deactivate`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)

`define`
* sanitize user input (RAM, CPU cores, volume capacity, network name, OS variant, pool/VM names) (__DONE__)
* improve the matching of network/OS variant/pool/VM names with dashes (__DONE__)

`getmac`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)
* handle domains with more than one virtual Ethernet adapters

`ping`
* sanitize user input (packet count, VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)

`reboot`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)

