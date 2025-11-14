#!/bin/bash
# mount disk.qcow2 file via Qemu tools

#qemu_nbd Network Block Device (Disk)
sudo modprobe nbd

QCOW2_FILE=/home/chris/my_qemu/ubuntucinnamon-24.10/disk.qcow2
NBD_PARTITION=/dev/nbd0p2

set -e #exit script when a command returns with exitcode not being zero

if [[ -f $QCOW2_FILE ]] #check if the file exists
then
	echo "OK: $QCOW2_FILE exists."
	sudo qemu-nbd -c /dev/nbd0 --read-only $QCOW2_FILE
	sleep 1 #needs some time before doing the mount to make it work
	udisksctl mount -b $NBD_PARTITION
else
   echo "Didn't find the file $QCOW2_FILE"
fi

exit 0


##################
#
# More info
#
##################

#Commands to mount:
sudo modprobe nbd
sudo qemu-nbd -c /dev/nbd0 --read-only /home/chris/my_qemu/ubuntucinnamon-24.10/disk.qcow2
udisksctl mount -b /dev/nbd0p2

#commands to unmount:
udisksctl unmount -b /dev/nbd0p2
sudo qemu-nbd -d /dev/nbd0 #disconnect the device
sudo modprobe -r nbd


#seen mounted as:
/media/chris/3008afaa-451a-417a-a021-17fcf362fb56
#Videos dir:
ls -ltr /media/chris/3008afaa-451a-417a-a021-17fcf362fb56/home/chris/Downloads/

