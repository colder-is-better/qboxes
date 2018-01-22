This is an alphabetical list of the currently implemented and also planned `qboxes` commands. For some of them there are bullet points regarding functionality/features we plan on adding.

`activate`
* __all_done__

`annihilate`
* facilitate the deletion of networks, pools, volumes

`attach`
* new volumes should be instantiated by `create volume` command
* support the addition of network adapters

`build`
* create a new VM starting with one or more existing storage volumes

`check-service`
* __all_done__

`clone`
* indicate network for clones
* handle the cloning of "empty" VMs
* clone VMs with more than one storage volumes

`create`
* facilitate the creation of volumes (QCOW2 sparse files)

`deactivate`
* __all_done__

`define`
* __all_done__

`getmac`
* handle VMs with more than one virtual Ethernet adapters

`info`
* return detailed information on VMs, networks, pools, volumes

`list`
* show VM hostnames
* show MAC address of primary network adapter and IP address (if applicable)

`modify`
* support the changing of RAM & number of cores (VMs)
* support the addition/removal of static mappings (networks)

`ping`
* __all_done__

`reboot`
* __all_done__

`power-cycle`
* forcibly restart VMs

`power-down`
* forcibly power-off VMs
