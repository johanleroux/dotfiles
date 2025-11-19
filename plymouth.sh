#!/usr/bin/env bash
set -euo pipefail

NEW_HOOKS="base udev plymouth autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck"
CONF="/etc/mkinitcpio.conf"

echo "Updating HOOKS in $CONF"
sudo sed -i -E "s|^HOOKS=.*$|HOOKS=(${NEW_HOOKS})|" "$CONF"

# Check if the theme is not already set
current_theme=$(plymouth-set-default-theme)
if [[ "$current_theme" != "arch-mac-style" ]]; then
    echo "Selecting Plymouth theme"
    sudo cp -r ./assets/arch-mac-style /usr/share/plymouth/themes/
    sudo plymouth-set-default-theme -R arch-mac-style
fi

[[ -f /boot/EFI/limine/limine.conf ]] || [[ -f /boot/EFI/BOOT/limine.conf ]] && EFI=true

# Conf location is different between EFI and BIOS
if [[ -n "$EFI" ]]; then
    # Check USB location first, then regular EFI location
    if [[ -f /boot/EFI/BOOT/limine.conf ]]; then
        limine_config="/boot/EFI/BOOT/limine.conf"
    else
        limine_config="/boot/EFI/limine/limine.conf"
    fi
    else
        limine_config="/boot/limine/limine.conf"
fi

# Remove the original config file if it's not /boot/limine.conf
if [[ "$limine_config" != "/boot/limine.conf" ]] && [[ -f "$limine_config" ]]; then
    sudo rm "$limine_config"
fi

# Double-check and exit if we don't have a config file for some reason
if [[ ! -f $limine_config ]]; then
    echo "Error: Limine config not found at $limine_config" >&2
    exit 1
fi

echo "Regenerating initramfs"
sudo limine-update
