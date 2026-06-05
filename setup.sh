#!/bin/bash

echo "Installing The SatellaOS System"

Repo=$HOME/satellaos-install-tool-cr
Base=$HOME/satellaos-install-tool-cr/tree-installer-system

# Repository update
if [ -d "$Repo/.git" ]; then
    echo "Repository found, updating..."
    git -C "$Repo" pull --rebase
else
    echo "Repository not found, cloning..."
    git clone "https://github.com/satellaos-official/satellaos-install-tool-cr.git" "$Repo"
fi

#--------------------------------------------------------------------------------------------------------------------------------------------

# 01 - Installing The Setup Dependencies

bash $Base/dependencies/run.sh

# 02 - Updating The adduser File

bash $Base/update-adduser/run.sh

# 03 - Installing The Network Manager Dependencies

bash $Base/install-network-manager/run.sh

# 04 - Connecting The Wifi with nmcli

python3 $Base/wifi-translator/run.py

# 05 - Cleaning The /etc/network/interfaces File

bash $Base/clean-network-interfaces/run.sh

# 06 - Enabling The Debian NON-FREE Repos

bash $Base/update-apt-sources/run.sh

# 07 - Installing The Core Dependencies

bash $Base/core/run.sh

# 08 - Updating The /etc/os-release File

bash $Base/update-os-release/run.sh

# 09 - Silent The Unwanted Kernel Messages

bash $Base/silent-kernel/run.sh

# 10 - Updating The GRUB Screen Settings

bash $Base/grub-settings/run.sh

# 11 - Installing The GRUB Theme

bash $Base/grub-theme/run.sh

# 12 - Copying The Image Files

bash $Base/pictures/run.sh

# 13 - Installing The Themes

bash $Base/themes/run.sh

# 14 - Being Configured The uca.xml File

bash $Base/uca-creator/run.sh --cli

# 15 - Configuration The Fastfetch File

bash $Base/fastfetch/run.sh