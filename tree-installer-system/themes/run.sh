#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "Changing The papirus-icon-theme Color to violet."

sudo wget https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders \
  -O /usr/bin/papirus-folders
  
sudo chmod +x /usr/bin/papirus-folders

MISSING_PKGS=()
for pkg in papirus-icon-theme; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    sudo apt install --install-recommends -y "${MISSING_PKGS[@]}"
fi

wget -q -O "/tmp/papirus-color-manager.py" "https://raw.githubusercontent.com/satellaos-official/satellaos-packages/refs/heads/main/satellaos-tools/satellaos-papirus-color-manager/core/papirus-color-manager.py"

python3 "/tmp/papirus-color-manager.py" --m --color violet

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "Installing The Fluent GTK Theme to System"

MISSING_PKGS=()
for pkg in libsass1 sassc; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    sudo apt install --install-recommends -y "${MISSING_PKGS[@]}"
fi

git clone https://github.com/vinceliuice/Fluent-gtk-theme.git /tmp/Fluent-gtk-theme

sudo /tmp/Fluent-gtk-theme/install.sh --dest /usr/share/themes --theme all --tweaks solid

rm -rf /tmp/Fluent-gtk-theme

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "Installing The Theme Dependencies"

MISSING_PKGS=()
for pkg in adwaita-qt bibata-cursor-theme gnome-themes-extra; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    sudo apt install --install-recommends -y "${MISSING_PKGS[@]}"
fi