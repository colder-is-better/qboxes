This is an alphabetical list of the currently implemented and also planned `qboxes` commands. For some of them there are bullet points regarding functionality/features we plan on adding.

`activate`
* __all_done__

`annihilate`
* __done__

`assimilate`
* __done__

`attach`
* new volumes should be existing ones 
* this command should act on a single VM
* facilitate the attachment of networks, optical media

`check-service`
* __all_done__

`clone`
* optional: indicate network for clones
* optional: indicate storage pool for clones (it is currently mandatory)
* handle the cloning of VMs with zero-sized storage volumes
* clone VMs with more than one storage volumes

`create`
* facilitate the creation of isolated libvirt networks

`deactivate`
* __all_done__

`define`
* volumes should be existing ones or instantiated by the `create volume` command
* this command should act on a single VM

`detach`
* facilitate the dettachment of networks, volumes, optical media

`getmac`
* __all_done__

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
* __all_done__

`reboot`
* __all_done__

`powcycle`
* __all_done__

`snapshot`
* facilitate the creation, removal and listing of VM snapshots

`unplug`
* __all_done__
