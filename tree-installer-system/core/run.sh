#!/bin/bash
# --------------------------------------------------
# Core desktop packages and services setup
# Provides a usable XFCE-based system
# --------------------------------------------------
echo "Installing core system and XFCE desktop..."
sudo apt update
sudo apt install --no-install-recommends -y \
  alsa-utils \
  dbus-x11 \
  gvfs \
  gvfs-backends \
  gvfs-fuse \
  lightdm \
  lightdm-gtk-greeter \
  ntfs-3g \
  orca \
  pavucontrol \
  pulseaudio \
  thunar \
  thunar-archive-plugin \
  udiskie \
  udisks2 \
  x11-xserver-utils \
  xfce4 \
  xfce4-battery-plugin \
  xfce4-clipman \
  xfce4-clipman-plugin \
  xfce4-datetime-plugin \
  xfce4-docklike-plugin \
  xfce4-indicator-plugin \
  xfce4-notifyd \
  xfce4-panel \
  xfce4-panel-profiles \
  xfce4-power-manager \
  xfce4-power-manager-data \
  xfce4-power-manager-plugins \
  xfce4-pulseaudio-plugin \
  xfce4-screensaver \
  xfce4-session \
  xfce4-settings \
  xfce4-terminal \
  xfce4-whiskermenu-plugin \
  xfdesktop4 \
  xfwm4 \
  xorg
  
# --------------------------------------------------
# Fonts, themes, and visual customization
# Cosmetic and personalization packages
# --------------------------------------------------
echo "Installing fonts and visual customization..."
sudo apt install --install-recommends -y \
  fonts-bebas-neue \
  fonts-montserrat 

# --------------------------------------------------
# PolicyKit (GUI authorization support)
# --------------------------------------------------
echo "Installing policykit components..."
sudo apt install --no-install-recommends -y \
  mate-polkit \
  pkexec \
  polkitd