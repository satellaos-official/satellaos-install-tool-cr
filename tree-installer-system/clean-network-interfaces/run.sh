#!/bin/bash

echo "Cleaning The interfaces File"

HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

Base=$HOME/satellaos-install-tool-cr/tree-installer-system

sudo rsync -ahP $Base/clean-network-interfaces/interfaces /etc/network/interfaces
