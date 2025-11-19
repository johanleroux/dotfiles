#!/usr/bin/env bash
set -euo pipefail

# ================================
#  CONFIGURE YOUR HOOKS HERE
# ================================
NEW_HOOKS="base plymouth udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck"

CONF="/etc/mkinitcpio.conf"
BACKUP="/etc/mkinitcpio.conf.bak-$(date +%Y%m%d-%H%M%S)"

# Make sure script runs as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

echo "Creating backup: $BACKUP"
cp "$CONF" "$BACKUP"

echo "Updating HOOKS in $CONF"

# Replace the HOOKS=() line, regardless of spacing or quoting format
sed -i -E "s|^HOOKS=.*$|HOOKS=(${NEW_HOOKS})|" "$CONF"

echo "Done."
echo "New HOOKS set to:"
echo "  $NEW_HOOKS"

echo "Rebuilding initramfs..."
mkinitcpio -P

sudo cp -r ./assets/arch-mac-style /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R arch-mac-style
