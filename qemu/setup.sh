#!/usr/bin/env bash

set -euo pipefail

VM_NAME=${1:-fedora}
DISK_URL=${2:-https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/images/Fedora-Server-KVM-38-1.6.x86_64.qcow2}

VM_DIRECTORY="${HOME}/.var/qemu/${VM_NAME}"

mkdir -p "${VM_DIRECTORY}"

if [ ! -f "${VM_DIRECTORY}/${VM_NAME}.qcow2" ]; then
    wget -O "${VM_DIRECTORY}/${VM_NAME}.qcow2" "${DISK_URL}"
    qemu-img resize "${VM_DIRECTORY}/${VM_NAME}.qcow2" 50G
fi

# Use these 2 links to increase the size of the disk:
# https://ahelpme.com/software/qemu/expand-disk-and-the-root-partition-of-the-qemu-virtual-server/
# https://unix.stackexchange.com/a/583544

sudo qemu-system-x86_64 -cpu host,-pdpe1gb -accel hvf -smp 6 -m 8192 \
    -hda "${VM_DIRECTORY}/${VM_NAME}.qcow2" \
    -netdev user,id=net0 -nic vmnet-host -rtc base=localtime \
    -device virtio-net-pci,netdev=net0 \
    -display none -nographic \
    -pidfile "${HOME}/.var/qemu/pidfile"

echo "Waiting for the system to come online..."
if nc -zw 0 192.168.56.2 22 &> /dev/null; then
    echo "System up and ready to go!"
else
    echo >&2 "Failed to connect to remote system"
fi
