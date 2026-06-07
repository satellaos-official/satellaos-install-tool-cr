#!/bin/bash

echo "Cleaning The interfaces File"

if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME="$HOME"
fi

SOURCE="$REAL_HOME/satellaos-install-tool-cr/tree-installer-system/clean-network-interfaces/interfaces"

if [ ! -f "$SOURCE" ]; then
    echo "ERROR: Source file not found: $SOURCE"
    exit 1
fi

sudo cp "$SOURCE" /etc/network/interfaces
