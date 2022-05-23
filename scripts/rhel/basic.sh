#!/bin/bash
set -e
dnf -y update
dnf -y install make nano jq wget golang kernel-devel
