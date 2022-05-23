#!/bin/bash
set -e

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Copy kubeconfig file to vagrant shared directory.
cp /etc/rancher/k3s/k3s.yaml /artifacts/
