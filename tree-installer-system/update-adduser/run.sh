#!/bin/bash

echo "Updating The adduser.conf File"

HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

Base=$HOME/satellaos-install-tool-cr/tree-installer-system

sudo rsync -ahP $Base/update-adduser/adduser.conf /etc/adduser.conf