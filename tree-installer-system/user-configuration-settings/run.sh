#!/bin/bash
set -e
set -u

BASE="$HOME/satellaos-install-tool-cr/tree-installer-system/user-configuration-settings/backup/"

echo "Restoring XFCE configuration and autostart settings..."

# ============================================================
# XFCE and Autostart
# ============================================================

mkdir -p "$HOME/.config/"

cp -r "$BASE/"* "$HOME/.config/"

cp -r "$BASE/"* "$HOME/.config/"

rm -rf $HOME/.bashrc

echo "Restore of XFCE configuration and autostart settings is complete."