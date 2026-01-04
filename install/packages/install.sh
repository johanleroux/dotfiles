#!/usr/bin/env bash

if ! command -v yay &> /dev/null
then
    echo "yay could not be found"
    echo "Installing yay"

    #!/usr/bin/env bash
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm yay -rf
fi

yay -S --needed --noconfirm - < $INSTALL_PATH/packages/pkg.list
echo "Packages installed"

