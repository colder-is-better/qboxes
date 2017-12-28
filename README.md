# Happy qboxes
This is a very simple BASH script for managing QEMU/KVM VMs. Currently, `qboxes` can:

* define one or more new VMs (with no OSes)
* clone a template VM into one or more new VMs
* bring inactive VMs up or shutdown/restart active VMs
* attach storage volumes to VMs
* remove any trace of inactive VMs
* reveal MAC addresses
* send ICMP packets to active VMs
* check if active VMs are reachable via a specific TCP port
* attach storage volumes to VMs

To get an overview of the tool just type `qboxes`.

```
This is qboxes, a simple command line tool for managing local QEMU/KVM VMs.
Currently the following commands are implemented:

  activate		: bring inactive VMs up
  annihilate	: remove any trace of inactive VMs
  attach		: attach storage volumes to (in)active VMs
  check-service	: attempt to connect to specified TCP port of one or more active VMs
  clone			: clone a template VM into one or more new VMs
  deactivate	: shutdown active VMs
  define		: define one or more new VMs
  getmac		: reveal MAC addresses
  ping			: send ICMP packets to active VMs
  reboot		: restart active VMs

  help			: display this summary of commands

Type qboxes command-name for the syntax and a usage example of a specific command.
```

The script requires a working installation of libvirt and the presence of tools like `virsh`, `virt-clone`, `virt-install` and `virt-customize`. The user running `qboxes` should be in the `libvirt` group and have (preferably passwordless) sudo privileges. Last but not least, the `LIBVIRT_DEFAULT_URI` environment variable should be properly set for the local system (`export LIBVIRT_DEFAULT_URI=qemu:///system` should be enough).

There are still many commands (functions) that we would like to implement in `qboxes`. See `TODO.md` for our (near) future plans.
