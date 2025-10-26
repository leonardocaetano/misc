#!/bin/bash

# to create the harddisk do the following command:
# qemu-img create -f qcow2 <name>.qcow2 16G
#

qemu-system-x86_64 \
    -enable-kvm \
    -m 2048 \
    -nic user,model=virtio \
    -drive file=arch.qcow2,media=disk,if=virtio \
        -cdrom arch.iso \
#     -sdl
