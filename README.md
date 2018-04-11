# Happy qboxes
This is a very simple BASH script for managing QEMU/KVM VMs. Currently, `qboxes` can:

* define one or more new VMs (with no guest OSes)
* clone a template VM into one or more new VMs
* bring inactive VMs up or reboot/shutdown/power-cycle/unplug active VMs
* attach new storage volumes to VMs
* integrate files into existing active storage pools
* remove any trace of inactive VMs, active networks, active pools, or volumes
* create new libvirt networks, pools, or volumes
* reveal MAC addresses
* list all available VMs, libvirt networks, pools, or volumes
* send ICMP packets to active VMs
* check if active VMs are reachable via a specific TCP port

To get an overview of the tool just type `qboxes`.

```
This is qboxes, a simple command line tool for managing local QEMU/KVM VMs.
Currently the following commands are implemented:

  activate	: bring inactive VMs up
  annihilate	: remove any trace of inactive VMs, active networks, active pools, or volumes
  assimilate	: integrate a file (ISO, QCOW2, etc.) into an existing active storage pool
  attach	: attach new storage volumes to (in)active VMs
  check-service	: try to connect to specified TCP port of one or more active VMs
  clone		: clone a template VM into one or more new VMs
  create	: create a new libvirt network, a new pool, or a new volume
  deactivate	: gracefully shutdown active VMs
  define	: define one or more new VMs
  getmac	: reveal MAC addresses
  list		: return all available VMs, libvirt networks, pools, or volumes
  ping		: send ICMP packets to active VMs
  powcycle	: cold-restart active VMs
  reboot	: gracefully restart active VMs
  unplug	: force-power-off active VMs

  help		: display this summary of commands
  command help	: get help on specific command

Type qboxes command help for the syntax and a usage example of a specific command.
```

The script requires a working installation of libvirt and the presence of tools like `virsh`, `virt-clone`, `virt-install`, `virt-customize`, `virt-copy-out`, and `strings` (from package `binutils`). The user running `qboxes` should be in the `libvirt` group and have password-less sudo privileges. Last but not least, the `LIBVIRT_DEFAULT_URI` environment variable should be properly set for the local system (`export LIBVIRT_DEFAULT_URI=qemu:///system` should be enough).

There are still many commands (functions) that we would like to implement in `qboxes`. See `TODO.md` for our (near) future plans.
