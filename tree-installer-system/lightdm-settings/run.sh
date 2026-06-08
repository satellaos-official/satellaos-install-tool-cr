#!/bin/bash

echo "Updating The LightDM Settings"

if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME="$HOME"
fi

SOURCE_DIR="$REAL_HOME/satellaos-install-tool-cr/tree-installer-system/lightdm-settings/lightdm"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

sudo cp "$SOURCE_DIR"/* /etc/lightdm/