#!/bin/bash

DEVICE=/dev/xvdc
MKFS=/usr/sbin/mkfs
MOUNT=/usr/bin/mount
MP=/ibm

## Does device exist?

if [ ! -b ${DEVICE} ]
then
        echo "FATAL ERROR: ${DEVICE} not found."
        exit 2
fi


## Create a file system on the device
${MKFS}  -t xfs -f ${DEVICE}

## Create a mount point
mkdir ${MP}
chmod 777 ${MP}

## Modify /etc/fstab
echo "/dev/xvdc       /ibm    xfs    defaults        1       2" >> /etc/fstab

## Mount the filesystem
${MOUNT} ${MP}

##
chmod 777 ${MP}
