#!/usr/bin/env bash

echo "checking zsh version"
zsh --version

echo "setting zsh as default shell"
chsh -s $(which zsh)

echo "log out and log back in again to use your new default shell"
