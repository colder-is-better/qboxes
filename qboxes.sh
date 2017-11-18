#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

show_usage() {
	case "$1" in
		activate)
			printf "COMMAND NAME\n";
			printf "  activate - bring inactive VMs up\n\n";
			printf "SYNOPSIS\n";
			printf "  activate <inactive_VM_1> ... <inactive_VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Power one or more inactive VMs up\n"
			exit 1
			;;
		annihilate)
			printf "COMMAND NAME\n";
			printf "  annihilate - remove any trace of inactive VMs\n\n";
			printf "SYNOPSIS\n";
			printf "  annihilate <inactive_VM_1> ... <inactive_VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Undefine one or more inactive VMs, delete all associated storage volumes\n"
			exit 1
			;;
		attach)
			printf "COMMAND NAME\n";
			printf "  attach - attach storage volumes to VMs\n\n";
			printf "SYNOPSIS\n";
			printf "  attach --name=<volume_name> --size=<volume_size> --pool=<name> --vmdev=<VM_device> <VM_1> ... <VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Create sparse QCOW2 files in specified pool, attach them as virtual hard drives to VMs\n"
			exit 1
			;;
		check-service)
			printf "COMMAND NAME\n";
			printf "  check-service - check if connections to specified TCP port of a VM are possible\n\n";
			printf "SYNOPSIS\n";
			printf "  check-service --port=<tcp_port> <active_VM>\n\n";
			printf "DESCRIPTION\n";
			printf "  Check if given VM is reachable via specificied TCP port\n"
			exit 1
			;;
		clone)
			printf "COMMAND NAME\n";
			printf "  clone - clone a template VM into one or more new VMs\n\n";
			printf "SYNOPSIS\n";
			printf "  clone --template=<VM_0> --pool=<pool_name> <VM_1> ... <VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Clone an existing template VM into one or more new VMs, indicate an existing storage pool for the cloned volumes\n"
			exit 1
			;;
		deactivate)
			printf "COMMAND NAME\n";
			printf "  deactivate - shutdown active VMs\n\n";
			printf "SYNOPSIS\n";
			printf "  deactivate <active_VM_1> ... <active_VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Try to gracefully shutdown one or more active VMs\n"
			exit 1
			;;
		define)
			printf "COMMAND NAME\n";
			printf "  define - define one or more new VMs\n\n";
			printf "SYNOPSIS\n";
			printf "  define --ram=<size> --cores=<count> --disk-size=<capacity> --network=<name> --guest-os=<os_variant> --pool=<name> <VM_1> ... <VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Define one or more VMs according to specifications, do not install a guest OS on any of them\n"
			exit 1
			;;
		getmac)
			printf "COMMAND NAME\n";
			printf "  getmac - reveal MAC addresses\n\n";
			printf "SYNOPSIS\n";
			printf "  getmac <VM_1> ... <VM_k>\n\n";
			printf "DESCRIPTION\n";
			printf "  Reveal the first Ethernet adapter's MAC address of one or more VMs\n"
			exit 1
			;;
		ping)
			printf "COMMAND NAME\n";
			printf "  ping - send ICMP packets to active VMs\n\n";
			printf "SYNOPSIS\n";
			printf "  ping --count=<number_of_packets> <active_VM_1> ... <active_VM_k>\n\n";
			printf "DESCRIPTION\n";
        		printf "  Send a specified number of ICMP packets to one or more active VMs\n"
        		exit 1
			;;
		reboot)
			printf "COMMAND NAME\n";
			printf "  reboot - restart active VMs\n\n";
        		printf "SYNOPSIS\n";
        		printf "  reboot <active_VM_1> ... <active_VM_k>\n\n";
        		printf "DESCRIPTION\n";
        		printf "  Try to gracefully restart one or more active VMs\n"
        		exit 1
			;;
		*)
			printf "\nThis is ${GREEN}qboxes${NC}, a simple command line tool for managing local QEMU/KVM VMs.\n"
			printf "Currently the following commands are implemented:\n\n"
			printf "  activate\t: bring inactive VMs up\n"
			printf "  annihilate\t: remove any trace of inactive VMs\n"
			printf "  attach\t: attach storage volumes to VMs\n"
			printf "  check-service\t: check if connections to specified TCP port of a VM are possible\n"
			printf "  clone\t\t: clone a template VM into one or more new VMs\n"
			printf "  deactivate\t: shutdown active VMs\n"
			printf "  define\t: define one or more new VMs\n"
			printf "  getmac\t: reveal MAC addresses\n"
			printf "  ping\t\t: send ICMP packets to active VMs\n"
			printf "  reboot\t: restart active VMs\n\n"
			printf "  help\t\t: display this summary of commands\n\n"
			printf "Type ${GREEN}qboxes <command_name>${NC} to get the syntax of a specific command.\n\n"
			;;
	esac
}

activate_func() {
	LOWEST_NUM_ARGS=1
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage activate
	fi

	ALL_INACTIVE_VMS=$(virsh list --name --inactive)
	if [ "$ALL_INACTIVE_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single inactive VM (is LIBVIRT_DEFAULT_URI set?)\n"
		show_usage activate
	fi

	VMS_ACTIVATED=0
	for candidate; do
		VM_EXISTS=$(echo "$ALL_INACTIVE_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} $candidate is not an inactive VM\n"
		else
			printf "${GREEN}INFO:${NC} Powering inactive VM $candidate up\n"

			virsh --quiet start "$candidate"

			VIRSH_ERROR_CODE="$?"
			if [ $VIRSH_ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $VIRSH_ERROR_CODE\n"
			else
				VMS_ACTIVATED=$((VMS_ACTIVATED + 1))
			fi
			sleep 1
		fi
	done
	printf "${GREEN}SUMMARY:${NC} $VMS_ACTIVATED VM(s) successfully activated.\n"
}

annihilate_func() {
	LOWEST_NUM_ARGS=1
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage annihilate
	fi

	ALL_INACTIVE_VMS=$(virsh list --name --inactive)
	if [ "$ALL_INACTIVE_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single inactive VM (is LIBVIRT_DEFAULT_URI set?)\n"
		show_usage annihilate
	fi

	VMS_ANNIHILATED=0
	for candidate; do
		VM_EXISTS=$(echo "$ALL_INACTIVE_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} $candidate is not an inactive VM\n"
		else
			printf "${GREEN}INFO:${NC} Annihilating inactive VM $candidate\n"

			virsh --quiet undefine "$candidate" --remove-all-storage --wipe-storage

			VIRSH_ERROR_CODE="$?"
			if [ $VIRSH_ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $VIRSH_ERROR_CODE, terminating now.\n"
				exit 2
			fi
			VMS_ANNIHILATED=$((VMS_ANNIHILATED + 1))
		fi
	done
	printf "${GREEN}SUMMARY:${NC} $VMS_ANNIHILATED VM(s) successfully annihilated.\n"
}

attach_func() {
	LOWEST_NUM_ARGS=5
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage attach
	fi

	VOLUME_NAME=""
	VOLUME_SIZE=""
	POOL_NAME=""
	VM_DEV=""

	for ((argument=1 ; argument <= $((LOWEST_NUM_ARGS - 1)) ; argument++)); do
		PARAM=$(echo "$1" | awk -F= '{print $1}')
		VALUE=$(echo "$1" | awk -F= '{print $2}')
		case $PARAM in
			--name)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid volume name\n"
					exit 1
				fi
				VOLUME_NAME=$VALUE
				;;
			--size)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid volume size\n"
					exit 1
				fi
				VOLUME_SIZE=$VALUE
				;;
			--pool)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid pool name\n"
					exit 1
				fi
				POOL_NAME=$VALUE
				POOL_EXISTS=$(virsh pool-list | grep -w "$POOL_NAME")
				if [ "$POOL_EXISTS" == "" ]; then
					printf "${RED}ERROR:${NC} I cannot seem to find pool $POOL_NAME\n"
					exit 1
				fi
				;;
			--vmdev)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid device file\n"
					exit 1
				fi
				VM_DEV=$VALUE
				;;
			*)
				printf "${RED}ERROR:${NC} I do not recognize this '$PARAM' argument\n"
				show_usage attach
				;;
		esac
		shift
	done

	if [ "$VOLUME_NAME" == "" ] || [ "$VOLUME_SIZE" == "" ] || [ "$POOL_NAME" == "" ] || [ "$VM_DEV" == "" ]; then
		printf "${RED}ERROR:${NC} One of the required arguments has not been set\n"
		show_usage attach
	fi

	ALL_VMS=$(virsh list --name --all)
	if [ "$ALL_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single VM on this host (is LIBVIRT_DEFAULT_URI properly set?)\n"
		show_usage attach
	fi

	POOL_PATH=$(virsh pool-dumpxml "$POOL_NAME" | grep "<path>" | awk -F "<path>" '{ print $2 }' | awk -F "</path>" '{ print $1 }')
	VOLUMES_ATTACHED=0
	for candidate; do
		VM_EXISTS=$(echo "$ALL_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} VM $candidate does not seem to exist\n"
		else
			QCOW2_NAME="$candidate"_"$VM_DEV"_"$VOLUME_NAME"_"$VOLUME_SIZE".qcow2
			QCOW2_PATH="$POOL_PATH"/"$QCOW2_NAME"
			printf "${GREEN}INFO:${NC} Creating QCOW2 image $QCOW2_NAME for $candidate\n"

			virsh --quiet vol-create-as "$POOL_NAME" --name "$QCOW2_NAME" --capacity "$VOLUME_SIZE" --format qcow2

			VIRSH_ERROR_CODE="$?"
			if [ $VIRSH_ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $VIRSH_ERROR_CODE, terminating now.\n"
				exit 2
			fi
			printf "${GREEN}INFO:${NC} Attaching $QCOW2_NAME to $candidate\n\n"

			virsh --quiet attach-disk "$candidate" "$QCOW2_PATH" "$VM_DEV" --driver qemu --subdriver qcow2 --targetbus virtio --persistent

			VIRSH_ERROR_CODE="$?"
			if [ $VIRSH_ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $VIRSH_ERROR_CODE, terminating now.\n"
				exit 2
			fi
			VOLUMES_ATTACHED=$((VOLUMES_ATTACHED + 1))
		fi
	done
	printf "${GREEN}SUMMARY:${NC} $VOLUMES_ATTACHED storage volume(s) successfully attached.\n"
}

check-service_func() {
	NUM_ARGS=2
	if [ $# -ne $NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need exactly $NUM_ARGS)\n"
		show_usage check-service
	fi

	PARAM=$(echo "$1" | awk -F= '{print $1}')
	VALUE=$(echo "$1" | awk -F= '{print $2}')
	if [ "$PARAM" != "--port" ]; then
		printf "${RED}ERROR:${NC} I do not recognize this '$PARAM' argument\n"
		show_usage check-service
	else
		if [ "$VALUE" == "" ]; then
			printf "${RED}ERROR:${NC} Invalid TCP port\n"
			exit 1
		else
			TCP_PORT=$VALUE
		fi
	fi

	VM="$2"
	IS_ACTIVE=$(virsh list --name | grep -w "$VM")
	if [ "$IS_ACTIVE" == "" ]; then
		printf "${RED}ERROR:${NC} $VM is not an active VM\n"
		exit 2
	fi

	nc -z -w 1 "$VM" "$TCP_PORT" > /dev/null 2>&1

	ERROR_CODE="$?"
	if [ $ERROR_CODE == 0 ]; then
		printf "${GREEN}INFO:${NC} VM $VM is ${GREEN}accepting${NC} packets on port $TCP_PORT/TCP\n"
	else
		printf "${GREEN}INFO:${NC} VM $VM is ${RED}not accepting${NC} packets on port $TCP_PORT/TCP\n"
	fi
	exit $ERROR_CODE
}

clone_func() {
	LOWEST_NUM_ARGS=3
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage clone
	fi

	TEMPLATE_VM=""
	CLONE_POOL_NAME=""
	for ((argument=1 ; argument <= $((LOWEST_NUM_ARGS - 1)) ; argument++)); do
		PARAM=$(echo "$1" | awk -F= '{print $1}')
		VALUE=$(echo "$1" | awk -F= '{print $2}')
		case $PARAM in
			--template)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid template name\n"
					exit 1
				fi

				TEMPLATE_VM=$VALUE
				TEMPLATE_EXISTS=$(virsh list --name --inactive | grep -w "$TEMPLATE_VM")
				if [ "$TEMPLATE_EXISTS" == "" ]; then
					printf "${RED}ERROR:${NC} Template should be an existing inactive VM\n"
					exit 1
				fi
				;;
			--pool)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid pool name\n"
					exit 1
				fi

				CLONE_POOL_NAME=$VALUE
				POOL_EXISTS=$(virsh pool-list | grep -w "$CLONE_POOL_NAME")
				if [ "$POOL_EXISTS" == "" ]; then
					printf "${RED}ERROR:${NC} I cannot seem to find pool $CLONE_POOL_NAME\n"
					exit 1
				fi
				;;
			*)
				printf "${RED}ERROR:${NC} I do not recognize this '$PARAM' argument\n"
				show_usage clone
				;;
		esac
		shift
	done

	if [ "$TEMPLATE_VM" == "" ] || [ "$CLONE_POOL_NAME" == "" ]; then
		printf "${RED}ERROR:${NC} One of the required arguments is not set\n"
		show_usage clone
	fi

	TEMPLATE_POOL_NAME=""
	TEMPLATE_POOL_PATH=""
	TEMPLATE_VOLUME_PATH=$(virsh dumpxml "$TEMPLATE_VM" | grep "<source file='" | awk -F "='" '{ print $2 }' | awk -F "'/>" '{ print $1 }')
	ALL_POOLS=$(virsh pool-list --name)

	for pool in $ALL_POOLS; do
		VOLUMES_IN_POOL=$(virsh vol-list "$pool")
		TEMPLATE_VOLUME_IN_LIST=$(echo "$VOLUMES_IN_POOL" | grep "$TEMPLATE_VOLUME_PATH")
		if [ "$TEMPLATE_VOLUME_IN_LIST" != "" ]; then
			TEMPLATE_POOL_NAME=$pool
			TEMPLATE_POOL_PATH=$(virsh pool-dumpxml "$pool" | grep "<path>" | awk -F "<path>" '{ print $2 }' | awk -F "</path>" '{ print $1 }')
			ALL_POOLS=""
		fi
	done

	TEMPLATE_VOLUME_NAME=$(echo "$TEMPLATE_VOLUME_PATH" | awk -F "${TEMPLATE_POOL_PATH}/" '{ print $2 }')
	CLONES_CREATED=0
	ALL_VMS=$(virsh list --name --all)
	CLONE_POOL_PATH=$(virsh pool-dumpxml "$CLONE_POOL_NAME" | grep "<path>" | awk -F "<path>" '{ print $2 }' | awk -F "</path>" '{ print $1 }')

	for candidate; do
		VM_EXISTS=$(echo "$ALL_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" != "" ]; then
			printf "${YELLOW}WARNING:${NC} There is already a VM $candidate, so I am skipping this one\n"
		else
			CLONE_VOLUME_NAME="$candidate".qcow2

			printf "${GREEN}INFO:${NC} Cloning $TEMPLATE_VOLUME_NAME into $CLONE_VOLUME_NAME\n"

			virsh --quiet vol-clone --pool "$TEMPLATE_POOL_NAME" "$TEMPLATE_VOLUME_NAME" "$CLONE_VOLUME_NAME"

			ERROR_CODE="$?"
			if [ $ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $ERROR_CODE, terminating now.\n"
				exit 2
			fi

			if [ "$TEMPLATE_POOL_PATH" != "$CLONE_POOL_PATH" ]; then
				printf "${GREEN}INFO:${NC} Moving $CLONE_VOLUME_NAME between pools ($TEMPLATE_POOL_NAME ==> $CLONE_POOL_NAME)\n"
				sudo mv "$TEMPLATE_POOL_PATH"/"$CLONE_VOLUME_NAME" "$CLONE_POOL_PATH"/

				ERROR_CODE="$?"
				if [ $ERROR_CODE -ne 0 ]; then
					printf "${RED}ERROR:${NC} Operation failed, mv returned error code $ERROR_CODE, terminating now.\n"
					exit 2
				fi

				virsh --quiet pool-refresh "$TEMPLATE_POOL_NAME"
				virsh --quiet pool-refresh "$CLONE_POOL_NAME"
			fi

			printf "${GREEN}INFO:${NC} Cloning $TEMPLATE_VM into $candidate and attaching $CLONE_VOLUME_NAME to it\n"

			virt-clone --quiet -o "$TEMPLATE_VM" -n "$candidate" --preserve-data -f "$CLONE_POOL_PATH"/"$CLONE_VOLUME_NAME"

			ERROR_CODE="$?"
			if [ $ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virt-clone returned error code $ERROR_CODE, terminating now.\n"
				exit 2
			fi

			printf "${GREEN}INFO:${NC} Setting hostname for $candidate\n\n"

			sudo virt-customize --quiet -d $candidate --hostname $candidate

			ERROR_CODE="$?"
			if [ $ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virt-customize returned error code $ERROR_CODE\n"
			fi

			CLONES_CREATED=$((CLONES_CREATED + 1))
		fi
	done

	printf "${GREEN}SUMMARY:${NC} $CLONES_CREATED VM(s) successfully cloned from template VM $TEMPLATE_VM.\n"
}

deactivate_func() {
	LOWEST_NUM_ARGS=1
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage deactivate
	fi

	ALL_ACTIVE_VMS=$(virsh list --name)
	if [ "$ALL_ACTIVE_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single active VM (is LIBVIRT_DEFAULT_URI set?)\n"
		show_usage deactivate
	fi

	VMS_DEACTIVATED=0
	for candidate; do
		VM_EXISTS=$(echo "$ALL_ACTIVE_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} $candidate is not an active VM\n"
		else
			printf "${GREEN}INFO:${NC} Shutting active VM $candidate down\n"

			virsh --quiet shutdown $candidate

			VIRSH_ERROR_CODE="$?"
			if [ $VIRSH_ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $VIRSH_ERROR_CODE\n"
			else
				VMS_DEACTIVATED=$((VMS_DEACTIVATED + 1))
			fi
			sleep 1
		fi
	done
	printf "${GREEN}SUMMARY:${NC} $VMS_DEACTIVATED VM(s) successfully deactivated.\n"
}

define_func() {
	LOWEST_NUM_ARGS=7
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage define
	fi

	MEMORY_SIZE=""
	CPU_CORES=""
	VOLUME_CAPACITY=""
	LIBVIRT_NETWORK=""
	OS_VARIANT=""
	POOL_NAME=""

	for ((argument=1 ; argument <= $((LOWEST_NUM_ARGS - 1)) ; argument++)); do
		PARAM=$(echo "$1" | awk -F= '{print $1}')
		VALUE=$(echo "$1" | awk -F= '{print $2}')
		case $PARAM in
			--ram)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid memory size\n"
					exit 1
				fi
				MEMORY_SIZE=$VALUE
				;;
			--cores)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid CPU core count\n"
					exit 1
				fi
				CPU_CORES=$VALUE
				;;
			--disk-size)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid volume size\n"
					exit 1
				fi
				VOLUME_CAPACITY=$VALUE
				;;
			--network)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid network name\n"
					exit 1
				fi
				LIBVIRT_NETWORK=$VALUE
				NETWORK_EXISTS=$(virsh net-list | grep -w "$LIBVIRT_NETWORK")
				if [ "$NETWORK_EXISTS" == "" ]; then
					printf "${RED}ERROR:${NC} I cannot seem to find network $LIBVIRT_NETWORK\n"
					exit 1
				fi
				;;
			--guest-os)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid OS variant\n"
					exit 1
				fi
				OS_VARIANT=$VALUE
				VARIANT_EXISTS=$(osinfo-query os -f short-id | grep -w "$OS_VARIANT")
				if [ "$VARIANT_EXISTS" == "" ]; then
					printf "${RED}ERROR:${NC} I do not recognize OS variant $OS_VARIANT\n"
					exit 1
				fi
				;;
			--pool)
				if [ "$VALUE" == "" ]; then
					printf "${RED}ERROR:${NC} Invalid pool name\n"
					exit 1
				fi
				POOL_NAME=$VALUE
				POOL_EXISTS=$(virsh pool-list | grep -w "$POOL_NAME")
				if [ "$POOL_EXISTS" == "" ]; then
					printf "${RED}ERROR:${NC} I cannot seem to find pool $POOL_NAME\n"
					exit 1
				fi
				;;
			*)
				printf "${RED}ERROR:${NC} I do not recognize this '$PARAM' argument\n"
				show_usage define
				;;
		esac
		shift
	done

	if [ "$MEMORY_SIZE" == "" ] || [ "$CPU_CORES" == "" ] || [ "$VOLUME_CAPACITY" == "" ] || [ "$LIBVIRT_NETWORK" == "" ] || [ "$OS_VARIANT" == "" ] || [ "$POOL_NAME" == "" ]; then
		printf "${RED}ERROR:${NC} One of the required arguments is not set\n"
		show_usage define
	fi

	VMS_DEFINED=0
	ALL_VMS=$(virsh list --name --all)
	POOL_PATH=$(virsh pool-dumpxml "$POOL_NAME" | grep "<path>" | awk -F "<path>" '{ print $2 }' | awk -F "</path>" '{ print $1 }')

	for candidate; do
		VM_EXISTS=$(echo "$ALL_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" != "" ]; then
			printf "${YELLOW}WARNING:${NC} There is already a VM $candidate, so I am skipping this one\n"
		else
			RANDOM_ALPHANUM=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 20 | tr -d '\n')
			XML_PATH="$candidate"_"$RANDOM_ALPHANUM".xml
			QCOW2_NAME="$candidate".qcow2
			QCOW2_PATH="$POOL_PATH"/"$QCOW2_NAME"

			printf "${GREEN}INFO:${NC} Creating volume $QCOW2_NAME for VM $candidate\n"

			virsh --quiet vol-create-as "$POOL_NAME" --name "$QCOW2_NAME" --capacity "$VOLUME_CAPACITY" --format qcow2

			ERROR_CODE="$?"
			if [ $ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $ERROR_CODE, terminating now.\n"
				exit 2
			fi

			printf "${GREEN}INFO:${NC} Coming up with a detailed XML description of $candidate\n"

			virt-install --quiet --name "$candidate" --os-variant "$OS_VARIANT" \
			--memory "$MEMORY_SIZE" --cpu host --vcpus="$CPU_CORES" --network network="$LIBVIRT_NETWORK",model=virtio \
			--disk "$QCOW2_PATH",bus=virtio --boot network,hd --print-xml 1 > ~/"$XML_PATH"

			ERROR_CODE="$?"
			if [ $ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virt-install returned error code $ERROR_CODE, terminating now.\n"
				rm -f ~/"$XML_PATH"
				exit 2
			fi

			printf "${GREEN}INFO:${NC} Retracting sound card & tablet input devices from XML description\n"

			sed -i /"<sound model"/d ~/"$XML_PATH"
			sed -i /'<input type="tablet'/d ~/"$XML_PATH"

			printf "${GREEN}INFO:${NC} Defining VM $candidate\n\n"

			virsh --quiet define ~/"$XML_PATH" --validate

			ERROR_CODE="$?"
			if [ $ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $ERROR_CODE, terminating now.\n"
				rm -f ~/"$XML_PATH"
				exit 2
			fi

			rm -f ~/"$XML_PATH"

			VMS_DEFINED=$((VMS_DEFINED + 1))
		fi
	done
	printf "${GREEN}SUMMARY:${NC} $VMS_DEFINED VM(s) successfully defined.\n"
}

getmac_func() {
	LOWEST_NUM_ARGS=1
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage getmac
	fi

	ALL_VMS=$(virsh list --name --all)
	if [ "$ALL_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single VM on this host (is LIBVIRT_DEFAULT_URI set?)\n"
		show_usage getmac
	fi

	for candidate; do
		VM_EXISTS=$(echo "$ALL_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} I cannot seem to find this '$candidate' VM\n"
		else
			MAC_ADDR=$(virsh --quiet dumpxml "$candidate" | grep "mac address" | awk -F "<mac address='" '{ print $2 }' | awk -F "'/>" '{ print $1 }')
			printf "${GREEN}INFO:${NC} $candidate looks like $MAC_ADDR\n"
		fi
	done
}

ping_func() {
	LOWEST_NUM_ARGS=2
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage ping
	fi

	PARAM=$(echo "$1" | awk -F= '{print $1}')
	VALUE=$(echo "$1" | awk -F= '{print $2}')

	if [ "$PARAM" != "--count" ]; then
		printf "${RED}ERROR:${NC} I do not recognize this '$PARAM' argument\n"
		show_usage ping
	else
		if [ "$VALUE" == "" ]; then
			printf "${RED}ERROR:${NC} Invalid number of packets\n"
			exit 1
		else
			HOW_MANY="$VALUE"
			shift
		fi
	fi

	ALL_ACTIVE_VMS=$(virsh list --name)
	if [ "$ALL_ACTIVE_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single active VM on this host (is LIBVIRT_DEFAULT_URI properly set?)\n"
		show_usage ping
	fi

	for candidate; do
		VM_EXISTS=$(echo "$ALL_ACTIVE_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} $candidate is not an active VM\n"
		else
			printf "${GREEN}INFO:${NC} Now pinging $candidate\n"
			/usr/bin/ping -c "$HOW_MANY" "$candidate"
		fi
	done
}

reboot_func() {
	LOWEST_NUM_ARGS=1
	if [ $# -lt $LOWEST_NUM_ARGS ]; then
		printf "${RED}ERROR:${NC} Incorrect number of arguments (I need at least $LOWEST_NUM_ARGS)\n"
		show_usage reboot
	fi

	ALL_ACTIVE_VMS=$(virsh list --name)
	if [ "$ALL_ACTIVE_VMS" == "" ]; then
		printf "${RED}ERROR:${NC} I cannot seem to find a single active VM (is LIBVIRT_DEFAULT_URI set?)\n"
		show_usage reboot
	fi

	VMS_DEFINED=0
	for candidate; do
		VM_EXISTS=$(echo "$ALL_ACTIVE_VMS" | grep -w "$candidate")
		if [ "$VM_EXISTS" == "" ]; then
			printf "${YELLOW}WARNING:${NC} $candidate is not an active VM\n"
		else
			printf "${GREEN}INFO:${NC} Rebooting active VM $candidate\n"

			virsh --quiet reboot "$candidate";

			VIRSH_ERROR_CODE="$?"
			if [ $VIRSH_ERROR_CODE -ne 0 ]; then
				printf "${RED}ERROR:${NC} Operation failed, virsh returned error code $VIRSH_ERROR_CODE\n"
			else
				VMS_DEFINED=$((VMS_DEFINED + 1))
			fi
			sleep 1
		fi
	done
	printf "${GREEN}SUMMARY:${NC} $VMS_DEFINED VM(s) successfully rebooted.\n"
}

case "$1" in
	activate)
		shift
		activate_func "$@"
		;;
	annihilate)
		shift
		annihilate_func "$@"
		;;
	attach)
		shift
		attach_func "$@"
		;;
	check-service)
		shift
		check-service_func "$@"
		;;
	clone)
		shift
		clone_func "$@"
		;;
	deactivate)
		shift
		deactivate_func "$@"
		;;
	define)
		shift
		define_func "$@"
		;;
	getmac)
		shift
		getmac_func "$@"
		;;
	ping)
		shift
		ping_func "$@"
		;;
	reboot)
		shift
		reboot_func "$@"
		;;
	*)
		show_usage help
		;;
esac
