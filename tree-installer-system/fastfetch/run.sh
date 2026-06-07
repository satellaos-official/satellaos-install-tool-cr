#!/bin/bash

if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME="$HOME"
fi

Base="$REAL_HOME/satellaos-install-tool-cr/tree-installer-system"

read -p "Do you want to install fastfetch? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then

    MISSING_PKGS=()
    for pkg in fastfetch; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            MISSING_PKGS+=("$pkg")
        fi
    done

    if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
        apt install --no-install-recommends -y "${MISSING_PKGS[@]}"
    fi

    echo "▶ Fastfetch installed successfully."
else
    echo "▶ Fastfetch installation skipped."
fi

read -p "Do you want to install a fastfetch theme? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then

    mkdir -p "$REAL_HOME/.config/fastfetch"

    cp "$Base/fastfetch/config.jsonc" "$REAL_HOME/.config/fastfetch/"

    echo "▶ Theme installed successfully."
else
    echo "▶ Theme installation skipped."
fi

echo "▶ Process completed."
