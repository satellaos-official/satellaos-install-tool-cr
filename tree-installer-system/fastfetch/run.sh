#!/bin/bash

Base=$HOME/satellaos-install-tool-cr/tree-installer-system

HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

read -p "Do you want to install fastfetch? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then

    MISSING_PKGS=()
    for pkg in fastfetch; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            MISSING_PKGS+=("$pkg")
        fi
    done

    if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
        sudo apt install --no-install-recommends -y "${MISSING_PKGS[@]}"
    fi

    echo "▶ Fastfetch installed successfully."
else
    echo "▶ Fastfetch installation skipped."
fi

read -p "Do you want to install a neofetch theme? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then

    mkdir -p "$HOME/.config/fastfetch"

    rsync -ahP "$Base/fastfetch/config.jsonc" "$HOME/.config/fastfetch/"

    echo "▶ Theme installed successfully."
else
    echo "▶ Theme installation skipped."
fi

echo "▶ Process completed."