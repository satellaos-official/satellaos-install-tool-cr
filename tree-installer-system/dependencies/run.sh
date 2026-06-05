#!/bin/bash

echo "Installing the SatellaOS Dependencies"

MISSING_PKGS=()
for pkg in rsync wget curl git; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    sudo apt install --no-install-recommends -y "${MISSING_PKGS[@]}"
fi
