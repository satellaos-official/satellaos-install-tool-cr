#!/bin/bash

echo "Installing The Flatpak..."

sudo apt install --install-recommends -y flatpak flatpak-xdg-utils
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Flatpak Installing is Complete"