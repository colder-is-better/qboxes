This is an alphabetical list of the currently implemented `qboxes` commands. Following each command is a short description of the functionality/features we plan on adding to it.

`activate`
* sanitize user input (VM names) (__DONE__)

`annihilate`
* sanitize user input (VM names) (__DONE__)
* delete DHCP leases of annihilated domains (see `virbr*.status` files, in `/var/lib/libvirt/dnsmasq`)

`attach`
* sanitize user input (volume/pool/VM names, volume sizes) (pending __volume sizes__)
* before attaching a new volume, automatically pick the first available block device name (`vdb`, `vdc`, etc.)

`check-service`
* sanitize user input (TCP port number, VM name) (pending __TCP port number__)

`clone`
* sanitize user input (template/VM/pool names) (__DONE__)
* investigate failures while trying to clone "empty" VMs
* use virt-customize before moving volume to new pool
* clone VMs with more than one storage volumes

`deactivate`
* sanitize user input (VM names) (__DONE__)

`define`
* sanitize user input (RAM size, CPU core count, volume capacity, network name, OS variant, pool/VM names)

`getmac`
* handle domains with more than one virtual Ethernet adapters
* sanitize user input (VM names)

`ping`
* sanitize user input (packet count, VM names)

`reboot`
* sanitize user input (VM names)