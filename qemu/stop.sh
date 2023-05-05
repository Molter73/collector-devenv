#!/usr/bin/env bash

set -exuo pipefail

VM_NAME=${1:-fedora}
VM_DIRECTORY="${HOME}/.var/qemu/${VM_NAME}"

sudo kill "$(sudo cat "${VM_DIRECTORY}/pidfile")"
