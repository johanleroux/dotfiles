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

# Navigate to dotfiles directory
cd "$DOTFILES_DIR" || exit 1

# Loop through all subdirectories
for dir in */; do
    dir=${dir%/}  # remove trailing slash

    if [ "$dir" == "scripts" ]; then
        echo "Stowing $dir to /usr/local/bin..."
        sudo stow -t /usr/local/bin "$dir"
    else
        echo "Stowing $dir to \$HOME..."
        stow "$dir"
    fi
done

echo "✅ All stow operations completed!"
