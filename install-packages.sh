#!/bin/bash

if ! command -v yay &> /dev/null
then
    echo "yay could not be found"
    echo "installing yay"

    #!/bin/bash
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm yay -rf
fi

echo "installing packages"
yay -S --needed --noconfirm - < ./pkg.list
echo "packages installed"

