#!/usr/bin/env bash

NEW_HOOKS="base udev plymouth autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck"
CONF="/etc/mkinitcpio.conf"

echo "Updating HOOKS in $CONF"
sudo sed -i -E "s|^HOOKS=.*$|HOOKS=(${NEW_HOOKS})|" "$CONF"
sudo limine-update

# Check if the theme is not already set
current_theme=$(plymouth-set-default-theme)
if [[ "$current_theme" != "arch-mac-style" ]]; then
    echo "Selecting Plymouth theme"
    sudo cp -r ./assets/arch-mac-style /usr/share/plymouth/themes/
    sudo plymouth-set-default-theme -R arch-mac-style
fi
