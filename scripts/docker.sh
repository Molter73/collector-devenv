#!/bin/bash
set -e

# Install docker
curl https://get.docker.com | sh

# Add vagrant to docker group
usermod -aG docker vagrant

systemctl enable --now docker
