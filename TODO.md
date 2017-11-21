This is an alphabetical list of the currently implemented `qboxes` commands. Following each command is a short description of the functionality/features we plan on adding to it.

`activate`
* sanitize user input (VM names)

`annihilate`
* delete DHCP leases of annihilated domains (see `virbr*.macs` files, in `/var/lib/libvirt/dnsmasq`)
* sanitize user input (VM name)

`attach`
* before attaching a new volume, automatically pick the first available block device name (`vdb`, `vdc`, etc.)
* sanitize user input (volume/pool/VM names, volume sizes)

`check-service`
* sanitize user input (TCP port number, VM name)

`clone`
* investigate failures while trying to clone "empty" VMs
* use virt-customize before moving volume to new pool
* clone VMs with more than one storage volumes
* sanitize user input (template/VM/pool names)

`deactivate`
* sanitize user input (VM names)

`define`
* sanitize user input (RAM size, CPU core count, volume capacity, network name, OS variant, pool/VM names)

`getmac`
* handle domains with more than one virtual Ethernet adapters
* sanitize user input (VM names)

`ping`
* sanitize user input (packet count, VM names)

`reboot`
* sanitize user input (VM names)
