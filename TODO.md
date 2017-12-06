This is an alphabetical list of the currently implemented `qboxes` commands. Following each command is a short description of the functionality/features we plan on adding to it.

`activate`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)

`annihilate`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)
* delete DHCP leases of annihilated domains (see files in `/var/lib/libvirt/dnsmasq`)

`attach`
* sanitize user input (volume/pool/VM names, volume capacity) (pending __volume capacity__)
* improve the matching of pool/VM names with dashes (__DONE__)
* automatically pick the first available block device name (`vdb`, `vdc`, etc) for new volumes

`check-service`
* sanitize user input (TCP port number, VM name) (pending __TCP port number__)
* improve the matching of VM names with dashes (__DONE__)

`clone`
* sanitize user input (pool/VM names) (__DONE__)
* improve the matching of pool/VM names with dashes (__DONE__)
* investigate failures while trying to clone "empty" VMs
* use virt-customize before moving volume to new pool
* clone VMs with more than one storage volumes

`deactivate`
* sanitize user input (VM names) (__DONE__)
* improve the matching of VM names with dashes (__DONE__)

`define`
* sanitize user input (RAM, CPU cores, volume capacity, network name, OS variant, pool/VM names)
  (pending __RAM__, __CPU cores__, __volume capacity__)

`getmac`
* sanitize user input (VM names)
* improve the matching of VM names with dashes (__DONE__)
* handle domains with more than one virtual Ethernet adapters

`ping`
* sanitize user input (packet count, VM names) (pending __packet count__)
* improve the matching of VM names with dashes (__DONE__)

`reboot`
* sanitize user input (VM names)
* improve the matching of VM names with dashes (__DONE__)

