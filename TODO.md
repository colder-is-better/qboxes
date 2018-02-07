This is an alphabetical list of the currently implemented and also planned `qboxes` commands. For some of them there are bullet points regarding functionality/features we plan on adding.

`activate`
* __all_done__

`annihilate`
* facilitate the deletion of networks, pools, volumes

`attach`
* new volumes should be existing ones or instantiated by the `create volume` command
* support the addition of network adapters
* this command should act on a single VM (for many VMs we have the `clone` command)

`check-service`
* do not assume VM name equals hostname
* act upon IPs (can be extracted from libvirt DHCP leases or ARP tables)

`clone`
* optional: indicate network for clones
* optional: indicate storage pool for clones (it is currently mandatory)
* handle the cloning of "empty" VMs
* clone VMs with more than one storage volumes

`create`
* facilitate the creation of volumes (QCOW2 sparse files)

`deactivate`
* __all_done__

`define`
* volumes should be existing ones or instantiated by the `create volume` command
* this command should act on a single VM (for many VMs we have the `clone` command)

`getmac`
* handle VMs with more than one virtual Ethernet adapters

`info`
* return detailed information on VMs, networks, pools, volumes

`list`
* show MAC address of primary network adapter and IP address (if applicable)

`modify`
* support the changing of RAM & number of cores (VMs)
* support the addition/removal of static mappings (networks)

`ping`
* do not assume VM name equals hostname
* act upon IPs (can be extracted from libvirt DHCP leases or ARP tables)

`reboot`
* __all_done__

`power-cycle`
* force-restart VMs

`power-down`
* force-power-off VMs

`snapshot`
* facilitate the creation, removal and listing of VM snapshots
