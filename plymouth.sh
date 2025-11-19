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

  # We overwrite the whole thing knowing the limine-update will add the entries for us
  sudo tee /boot/limine.conf <<EOF >/dev/null
### Read more at config document: https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
#timeout: 3
default_entry: 2
interface_branding: Arch Limine Bootloader
interface_branding_color: 2
hash_mismatch_panic: no

term_palette: 24273a;ed8796;a6da95;eed49f;8aadf4;f5bde6;8bd5ca;cad3f5
term_palette_bright: 5b6078;ed8796;a6da95;eed49f;8aadf4;f5bde6;8bd5ca;cad3f5
term_background: 24273a
term_foreground: cad3f5
term_background_bright: 5b6078
term_foreground_bright: cad3f5

EOF

echo "Regenerating initramfs"
sudo limine-update

if efibootmgr &>/dev/null; then
    # Remove the archinstall-created Limine entry
    while IFS= read -r bootnum; do
        sudo efibootmgr -b "$bootnum" -B >/dev/null 2>&1
    done < <(efibootmgr | grep -E "^Boot[0-9]{4}\*? Arch Linux Limine" | sed 's/^Boot\([0-9]\{4\}\).*/\1/')
fi
