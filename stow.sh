#!/bin/bash

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null
then
    echo "GNU Stow is not installed. Please install it and try again."
    exit 1
fi

# Set your dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Verify the directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory '$DOTFILES_DIR' does not exist."
    exit 1
fi

# Check if the current directory is the dotfiles directory
if [ "$(pwd)" != "$DOTFILES_DIR" ]; then
    echo "Please run this script from the dotfiles directory: $DOTFILES_DIR"
    exit 1
fi

# Stow the bin directory to /usr/local/bin
echo "Stowing bin to /usr/local/bin..."
sudo stow -t /usr/local/bin bin

# Stow the directories inside config to $HOME
echo "Stowing config to $HOME..."
for dir in config/*; do
    if [ -d "$dir" ]; then
        dir=$(basename "$dir") # Remove config prefix
        dir=${dir%/} # Remove trailing slash if any
        stow -t "$HOME" -d "$DOTFILES_DIR/config" "$dir"
    fi
done

# Update desktop database after stowing mimetypes
update-desktop-database ~/.local/share/applications

echo "All stow operations completed!"
