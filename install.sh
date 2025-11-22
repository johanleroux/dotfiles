#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define path locations
export CURRENT_PATH="$(pwd)"
export INSTALL_PATH="$CURRENT_PATH/install"

# Install Packages
echo "Installing packages..."
source "$INSTALL_PATH/packages/install.sh"

# Stow dotfiles
echo "Stowing dotfiles..."
source "$CURRENT_PATH/stow.sh"

# Configure
echo "Configuring system..."
source "$INSTALL_PATH/config/all.sh"

