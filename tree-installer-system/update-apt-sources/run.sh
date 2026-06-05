#!/bin/bash

echo "Enabling The NON-FREE Repos"

HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

Base=$HOME/satellaos-install-tool-cr/tree-installer-system

sudo rsync -ahP $Base/update-apt-sources/sources.list /etc/apt/sources.list