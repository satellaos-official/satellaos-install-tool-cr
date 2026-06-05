#!/bin/bash

echo "Installing Network Manager"

MISSING_PKGS=()
for pkg in network-manager network-manager-applet wpasupplicant; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    sudo apt install --no-install-recommends -y "${MISSING_PKGS[@]}"
fi

sudo systemctl enable NetworkManager

sudo systemctl start NetworkManager
