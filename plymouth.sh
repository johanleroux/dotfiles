#!/usr/bin/env bash
set -euo pipefail

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

# Double-check and exit if we don't have a config file for some reason
if [[ ! -f $limine_config ]]; then
    echo "Error: Limine config not found at $limine_config" >&2
    exit 1
fi

  CMDLINE=$(grep "^[[:space:]]*cmdline:" "$limine_config" | head -1 | sed 's/^[[:space:]]*cmdline:[[:space:]]*//')

  sudo tee /etc/default/limine <<EOF >/dev/null
TARGET_OS_NAME="Custom Arch Linux"

ESP_PATH="/boot"

KERNEL_CMDLINE[default]="$CMDLINE"
KERNEL_CMDLINE[default]+="quiet splash"

ENABLE_UKI=yes
CUSTOM_UKI_NAME="arch"

ENABLE_LIMINE_FALLBACK=yes

# Find and add other bootloaders
FIND_BOOTLOADERS=yes

BOOT_ORDER="*, *fallback, Snapshots"

MAX_SNAPSHOT_ENTRIES=5

SNAPSHOT_FORMAT_CHOICE=5
EOF

# UKI and EFI fallback are EFI only
if [[ -z $EFI ]]; then
    sudo sed -i '/^ENABLE_UKI=/d; /^ENABLE_LIMINE_FALLBACK=/d' /etc/default/limine
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

# Remove the original config file if it's not /boot/limine.conf
if [[ "$limine_config" != "/boot/limine.conf" ]] && [[ -f "$limine_config" ]]; then
    sudo rm "$limine_config"
fi

echo "Regenerating initramfs"
sudo limine-update


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
