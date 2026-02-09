#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"
gsettings set org.gnome.desktop.interface scaling-factor 1 
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences default-sort-order 'mtime'
gsettings set org.gnome.nautilus.preferences default-sort-in-reverse-order true
sudo gtk-update-icon-cache /usr/share/icons/Yaru
