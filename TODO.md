This is an alphabetical list of the currently implemented and also planned `qboxes` commands. For some of them there are bullet points regarding functionality/features we plan on adding.

`activate`
* __all done__

`annihilate`
* __all done__

`assimilate`
* __all done__

`attach`
* facilitate the attachment of libvirt networks

`check-service`
* __all done__

`clone`
* optional: indicate network for clones
* optional: indicate storage pool for clones (it is currently mandatory)
* handle the cloning of VMs with zero-sized storage volumes
* clone VMs with more than one storage volumes

`create`
* facilitate the creation of isolated libvirt networks

`deactivate`
* __all done__

`define`
* __all done__

`detach`
* facilitate the dettachment of networks, volumes

`getmac`
* __all done__

`info`
* return detailed information on VMs, networks, pools, volumes

`list`
* check if network mentioned in XML of VM really exists (it may as well not) and report accordingly
* show MAC address of primary network adapter and IP address (if applicable)

`modify`
* support the changing of RAM & number of cores (VMs)

`rename`
* rename a VM

`ping`
* __all done__

`reboot`
* __all done__

`powcycle`
* __all done__

`snapshot`
* facilitate the creation, removal and listing of VM snapshots

`unplug`
* __all done__
