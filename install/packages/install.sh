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

# Enable multilib repository
if ! grep -Eq '^\s*\[multilib\]' /etc/pacman.conf; then
    echo "Enabling multilib repository"
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Sy
fi

cat $INSTALL_PATH/packages/*.list > /tmp/pkg.list

yay -S --needed --noconfirm --sudoloop - < /tmp/pkg.list
echo "Packages installed"
