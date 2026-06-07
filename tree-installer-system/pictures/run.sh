#!/bin/bash

echo "Installing The SatellaOS Pictures"

if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME="$HOME"
fi

Base="$REAL_HOME/satellaos-install-tool-cr/tree-installer-system"

mkdir -p /usr/share/satellaos-core/pictures/

rsync -ahP --chmod=D755,F644 "$Base/pictures/satellaos-sirius/" /usr/share/satellaos-core/pictures/
