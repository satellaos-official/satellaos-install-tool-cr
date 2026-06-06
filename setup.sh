#!/bin/bash

echo "Installing The SatellaOS System"

Repo=$HOME/satellaos-install-tool-cr
Base=$HOME/satellaos-install-tool-cr/tree-installer-system

confirm() {
  read -p "${1:-Do you want to continue?} [Y/N]: " choice
  case "$choice" in
    [Yy]* ) return 0;;
    [Nn]* ) return 1;;
    *     ) echo "Invalid input. Please enter Y or N."; return 1;;
  esac
}

# Repository update
if [ -d "$Repo/.git" ]; then
    echo "Repository found, updating..."
    git -C "$Repo" pull --rebase
else
    echo "Repository not found, cloning..."
    git clone "https://github.com/satellaos-official/satellaos-install-tool-cr.git" "$Repo"
fi

#----------------------------------------------------------------------------

# 01 - Installing The Setup Dependencies
bash $Base/dependencies/run.sh
confirm "Continue to 02 - Update adduser?" || exit 1

# 02 - Updating The adduser File
bash $Base/update-adduser/run.sh
confirm "Continue to 03 - Network Manager?" || exit 1

# 03 - Installing The Network Manager Dependencies
bash $Base/install-network-manager/run.sh
confirm "Continue to 04 - Wifi Connection?" || exit 1

# 04 - Connecting The Wifi with nmcli
python3 $Base/wifi-translator/run.py
confirm "Continue to 05 - Clean network interfaces?" || exit 1

# 05 - Cleaning The /etc/network/interfaces File
bash $Base/clean-network-interfaces/run.sh
confirm "Continue to 06 - Enable NON-FREE Repos?" || exit 1

# 06 - Enabling The Debian NON-FREE Repos
bash $Base/update-apt-sources/run.sh
confirm "Continue to 07 - Core Dependencies?" || exit 1

# 07 - Installing The Core Dependencies
bash $Base/core/run.sh
confirm "Continue to 08 - Update os-release?" || exit 1

# 08 - Updating The /etc/os-release File
bash $Base/update-os-release/run.sh
confirm "Continue to 09 - Silent Kernel Messages?" || exit 1

# 09 - Silent The Unwanted Kernel Messages
bash $Base/silent-kernel/run.sh
confirm "Continue to 10 - GRUB Settings?" || exit 1

# 10 - Updating The GRUB Screen Settings
bash $Base/grub-settings/run.sh
confirm "Continue to 11 - GRUB Theme?" || exit 1

# 11 - Installing The GRUB Theme
bash $Base/grub-theme/run.sh
confirm "Continue to 12 - Copy Image Files?" || exit 1

# 12 - Copying The Image Files
bash $Base/pictures/run.sh
confirm "Continue to 13 - Themes?" || exit 1

# 13 - Installing The Themes
bash $Base/themes/run.sh
confirm "Continue to 14 - Configure uca.xml?" || exit 1

# 14 - Being Configured The uca.xml File
bash $Base/uca-creator/run.sh --cli
confirm "Continue to 15 - Fastfetch Config?" || exit 1

# 15 - Configuration The Fastfetch File
bash $Base/fastfetch/run.sh

echo "SatellaOS Installation Complete!"