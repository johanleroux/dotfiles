# Arch Linux Installation Guide

This guide covers manual installation of Arch Linux as a base for with custom dotfiles provided by this repository.

*Inspired by [Omarchy](https://omarchy.org/)* following the [manual installation steps](https://learn.omacom.io/2/the-omarchy-manual/96/manual-installation).

## Prerequisites
- Arch Linux ISO on a USB stick (use balenaEtcher on Mac/Windows)
- Secure Boot disabled in BIOS
- **Important**: A wired or 2.4GHz dongle keyboard (Bluetooth won't work for disk encryption password entry at boot)

## Step 1: Network Setup

If using WiFi, run:
```bash
iwctl
station wlan0 scan
station wlan0 connect <tab>  # Select your network and enter password
```

Ethernet users can skip this step.

## Step 2: Run archinstall

Launch the installer:
```bash
archinstall
```

Configure the following options (leave others as default):

| Section | Option |
|---------|--------|
| **Mirrors and repositories** | Select regions → Your country |
| **Disk configuration** | Partitioning → Default partitioning layout → Select disk (space + return) |
| **Disk → File system** | btrfs (default structure: yes + use compression) |
| **Disk → Disk encryption** | Encryption type: LUKS + Set password + Select partition |
| **Hostname** | Choose a computer name |
| **Bootloader** | Limine |
| **Authentication → Root password** | Set your password |
| **Authentication → User account** | Add user → Superuser: Yes → Confirm and exit |
| **Applications → Audio** | pipewire |
| **Network configuration** | Copy ISO network config |
| **Additional packages** | git |
| **Timezone** | Select your timezone |

### ⚠️ Disk Encryption Warning

You **must** setup LUKS disk encryption for Omarchy! The system auto-logs in after disk decryption at boot. Make sure to:
1. Select LUKS encryption type
2. Set encryption password
3. **Apply to the partition** (crucial step!)

## Step 3: Complete Installation

After archinstall finishes:
1. Reboot
2. Login with your created user
3. Install dotfiles:
```bash
git clone https://github.com/johanleroux/dotfiles.git
cd dotfiles
./setup.sh
```
