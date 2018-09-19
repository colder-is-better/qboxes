# Happy qboxes
This is a very simple BASH script for managing QEMU/KVM VMs. Currently, `qboxes` can:

* define a new VM, with no guest OS
* clone a template VM into one or more new VMs
* activate/deactivate inactive/active VMs, libvirt networks, or storage pools
* reboot/power-cycle/unplug active VMs
* attach storage volumes to VMs
* integrate files into active storage pools
* remove any trace of inactive VMs, libvirt networks, storage pools, or volumes
* create new libvirt networks, storage pools, or volumes
* reveal VM MAC addresses
* list all available VMs, libvirt networks, storage pools, or volumes
* send ICMP packets to active VMs
* check if active VMs are reachable via specific TCP port

To get an overview of the tool just type `qboxes`.

```
This is qboxes, a simple command line tool for managing local QEMU/KVM VMs.
The following commands are currently implemented:

  activate	: bring inactive VMs up, or activate inactive libvirt networks, storage pools
  annihilate	: remove any trace of inactive VMs, libvirt networks, storage pools, or volumes
  assimilate	: integrate a file (ISO, QCOW2, etc.) into an active storage pool
  attach	: attach a storage volume to an (in)active VM
  check-service	: try to connect to specified TCP port of one or more active VMs
  clone		: clone a template VM into one or more new VMs
  create	: create a new libvirt network, a new storage pool, or a new volume
  deactivate	: gracefully shutdown active VMs, or deactivate active libvirt networks, storage pools
  define	: define a new VM, sans guest OS, according to specifications
  getmac	: reveal VM MAC addresses
  list		: return all available VMs, libvirt networks, storage pools, or volumes
  ping		: send ICMP packets to active VMs
  powcycle	: cold-restart active VMs
  reboot	: gracefully restart active VMs
  unplug	: force-power-off active VMs

  help		: display this summary of commands
  command help	: get help on specific command

Type qboxes command help for the syntax and a usage example of a specific command.
```

The script requires a working installation of libvirt and the presence of tools like `virsh`, `virt-clone`, `virt-install`, `virt-customize`, `virt-copy-out`, and `strings` (from package `binutils`). The user running `qboxes` should be in the `libvirt` group and have password-less sudo privileges. Last but not least, the `LIBVIRT_DEFAULT_URI` environment variable should be properly set for the local system (`export LIBVIRT_DEFAULT_URI=qemu:///system` should be enough).

There are still some commands (functions) that we would like to implement in `qboxes`. See `TODO.md` for our near future plans.
