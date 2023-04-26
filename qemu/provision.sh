#!/usr/bin/env bash

set -euo pipefail

VM_NAME="${1:-fedora}"

VM_DIRECTORY="${HOME}/.var/qemu/${VM_NAME}"

if [ ! -f "${VM_DIRECTORY}/id_rsa" ]; then
    ssh-keygen -t rsa -f "${VM_DIRECTORY}/id_rsa" -N ''
fi

ansible-playbook -i ansible/inventory.yml --ask-pass ../provision/provision.yml
