echo "Installing The SatellaOS Pictures"

HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

Base=/home/satella/satellaos-install-tool-cr/tree-installer-system

sudo mkdir -p /usr/share/satellaos-core/pictures/

sudo rsync -ahP --chmod=D755,F644 $Base/pictures/satellaos-sirius/ /usr/share/satellaos-core/pictures/