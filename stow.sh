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
        dir=${dir%/}
        stow -t "$HOME" "$dir"
    fi
done

echo "All stow operations completed!"
