#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"
gsettings set org.gnome.desktop.interface scaling-factor 1 
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5

sudo gtk-update-icon-cache /usr/share/icons/Yaru
