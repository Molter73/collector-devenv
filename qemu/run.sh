#!/usr/bin/env bash

set -euo pipefail

VM_NAME=${1:-fedora}
VM_DIRECTORY="${HOME}/.var/qemu/${VM_NAME}"

sudo qemu-system-x86_64 -cpu host,-pdpe1gb -accel hvf -smp 6 -m 8192 \
    -hda "${VM_DIRECTORY}/${VM_NAME}.qcow2" \
    -netdev user,id=net0 -device virtio-net-pci,netdev=net0 \
    -nic vmnet-host -rtc base=localtime -display none -daemonize \
    -pidfile "${VM_DIRECTORY}/pidfile"

echo "Waiting for the system to come online..."
if nc -zw 0 192.168.56.2 22 &> /dev/null; then
    echo "System up and ready to go!"
else
    echo >&2 "Failed to connect to remote system"
fi
