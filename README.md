# qboxes
This is a very simple BASH script for managing QEMU/KVM VMs. Currently, `qboxes` can perform the following functions:

* define one or more new VMs (with no OSes)
* clone a template VM into one or more new VMs
* bring inactive VMs up or shutdown/restart active VMs
* attach storage volumes to VMs
* remove any trace of inactive VMs
* reveal MAC addresses
* send ICMP packets to active VMs
* attach storage volumes to VMs

To get an overview of the tool just type `qboxes`:

```
This is qboxes, a simple command line tool for managing local QEMU/KVM VMs.
Currently the following commands are implemented:

  activate	: bring inactive VMs up
  annihilate	: remove any trace of inactive VMs
  attach	: attach storage volumes to VMs
  check-service	: check if connections to specified TCP port of a VM are possible
  clone		: clone a template VM into one or more new VMs
  deactivate	: shutdown active VMs
  define	: define one or more new VMs
  getmac	: reveal MAC addresses
  ping		: send ICMP packets to active VMs
  reboot	: restart active VMs

  help		: display this summary of commands

Type qboxes <command_name> to get the syntax of a specific command.
```

The script requires a working installation of libvirt and the presence of tools like `virsh`, `virt-clone`, `virt-install` and `virt-customize`. The user running `qboxes` should be in the `libvirt` group and have --preferably passwordless-- sudo privileges. Last but not least, the `LIBVIRT_DEFAULT_URI` environment variable should be properly set (e.g., `export LIBVIRT_DEFAULT_URI=qemu:///system`).

There are still many functions that we would like to implement in `qboxes`. We should also point out that at the time of this writing the scripts has some serious drawbacks (e.g. it does not properly sanitize all kinds of user input).
