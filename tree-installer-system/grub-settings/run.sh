#!/bin/bash

echo "Updating The GRUB BootLoader Settings"

HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

Base=$REAL_HOME/satellaos-install-tool-cr/tree-installer-system

sudo rsync -ahP $Base/grub-settings/grub /etc/default/grub

sudo update-grub

sudo update-initramfs -u