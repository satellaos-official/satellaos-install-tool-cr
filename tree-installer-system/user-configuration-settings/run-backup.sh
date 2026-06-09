#!/bin/bash
set -e
set -u

BASE="$HOME/satellaos-install-tool-cr/tree-installer-system/user-configuration-settings/backup/"
mkdir -p "$BASE"

echo "Backing up XFCE configuration and autostart settings..."

# ============================================================
# XFCE and Autostart
# ============================================================

cp -r "$HOME/.config/xfce4/" "$BASE/"

cp -r "$HOME/.config/autostart/" "$BASE/"

echo "Backup of XFCE configuration and autostart settings is complete."