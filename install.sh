#!/bin/sh

# Installer Version: 2.5
# A fork of https://github.com/manas140/dotfiles install.sh

# Directories
dir="$HOME/.config $HOME/Pictures/Wallpapers $HOME/.local/bin $HOME/.fonts $HOME/.config/backups"

# Variables
dotfiles="$(cd "$(dirname "$0")" && pwd)"
config="$HOME/.config"
bin="$HOME/.local/bin"

# Warning
printf "[*] PROCEDING WILL MAKE A BACKUP FOR ALL YOUR CONFIGS IN ($HOME/.config/backups)\n"
echo " "
printf "[*] Warning: Installer will replace the old backups with the current one is installed if the installer runs the second times.\n"
printf "[*] Please rename the backups folder or just move it to another location\n"
echo " "
read -p "[-] Do you want to proceed [Y/N] : " install

# Abort
case $install in
    N*|n*)
    printf "[-] Aborting!\n"
    echo " "
esac

# Install
case $install in
    Y*|y*)
    for a in $dir; do 
        mkdir -p $a # Makes the directories
    done


# Packages (Arch Only)
read -p "[-] Are you using Arch Linux [Y/N] : " arch

# Request sudo access
sudo echo ""

case $arch in
    Y*|y*)
    # Package (Arch Linux)
    printf "[*] Updating System\n" && sleep 1
    echo " "
    sudo pacman --noconfirm -Syu

    printf "[*] Installing Dependencies\n" && sleep 1
    echo " "
    sudo pacman -S --noconfirm --needed git xorg curl base-devel

    # Yay
    cd /opt/
    sudo rm yay -r
    sudo git clone https://aur.archlinux.org/yay.git
    sudo chown $USER:$USER yay
    cd yay
    makepkg -si
    yay -S --noconfirm bspwm-git sxhkd-git polybar-git rofi zsh kitty picom-ibhagwan-git dunst gtk3 gtk-engine-murrine gnome-themes-extra alsa alsa-utils feh volumectl brightnessctl bluez bluez-utils i3lock-color ksuperkey sddm rofi-bluetooth-git yad networkmanager networkmanager-dmenu-git cava nerd-fonts-jetbrains-mono ttf-jetbrains-mono ttf-iosevka ttf-iosevka-nerd xclip pulseaudio pulseaudio-alsa pulseaudio-bluetooth xbrightness xcolor mpd ncmpcpp mpc zathura polkit-gnome xfce4-power-manager viewnior maim xdg-user-dirs xdotool pavucontrol nautilus lxappearance-gtk3 mpv
esac

# Copying the old configs to backup folder
printf "[*] Making backups\n" && sleep 1
cp -rf $config/bspwm/ $config/backups
cp -rf $config/sxhkd/ $config/backups
cp -rf $config/polybar/ $config/backups
cp -rf $config/networkmanager-dmenu/ $config/backups
# cp -rf $config/nvim/ $config/backups
cp -rf $config/kitty/ $config/backups
cp -rf $config/dunst/ $config/backups
# cp -rf $config/zathura/ $config/backups
# cp -rf $config/cava/ $config/backups
cp -rf $config/picom.conf $config/backups
cp -rf $HOME/.Xresources $config/backups
cp -rf $HOME/.zshrc $config/backups
cp -rf $HOME/.ncmpcpp/ $config/backups
cp -rf $HOME/.mpd/ $config/backups
# cp -rf $HOME/.vimrc $config/backups
# cp -rf $HOME/.startpage/ $config/backups
cp -rf $bin $config/backups

# Removing old configs
printf "[*] Deleting old configs\n" && sleep 1
rm -rf $config/bspwm/
rm -rf $config/sxhkd/
rm -rf $config/polybar/
rm -rf $config/networkmanager-dmenu/
rm -rf $config/nvim/
rm -rf $config/kitty/
rm -rf $config/dunst/
rm -rf $config/zathura/
rm -rf $config/cava/
rm -rf $config/picom.conf
rm -rf $HOME/.Xresources
rm -rf $HOME/.zshrc
rm -rf $HOME/.ncmpcpp/
rm -rf $HOME/.mpd/
rm -rf $HOME/.vimrc
rm -rf $HOME/.startpage/
rm -rf $bin/*

# Setup
printf "[*] Copying dotfiles\n" && sleep 1
cp -rf $dotfiles/config/* $config/

printf "[*] Copying configs\n" && sleep 1
cp -rf $dotfiles/home/.[^.]* $HOME/
xrdb ~/.Xresources
printf "[*] Configs copied\n" && sleep 1

printf "[*] Copying scripts\n" && sleep 1
cp -rf $dotfiles/local/bin/* $bin/
sudo cp $dotfiles/local/bin/rofi-bluetooth /usr/bin/
printf "[*] Scripts copied\n" && sleep 1

printf "[*] Making them excutables\n" && sleep 1
chmod +x $bin/*
chmod +x $config/bspwm/bspwmrc
chmod +x $config/rofi/bin/*
chmod +x $config/polybar/launch.sh

printf "[*] Copying wallpapers\n" && sleep 1
cp -rf $dotfiles/home/Pictures/Wallpapers/* $HOME/Pictures/Wallpapers
printf "[*] Wallpapers copied\n" && sleep 1

printf "[*] Copying fonts\n" && sleep 1
cp -rf $dotfiles/fonts/* $HOME/.fonts
fc-cache -fv
printf "[*] Fonts copied\n" && sleep 1


printf "[*] Set themes\n" && sleep 1
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
printf "[*] Themes set\n" && sleep 1

printf "[*] Dotfiles installed\n" && sleep 1

# Finishing    
printf "[-] Done\n" && sleep 1
printf "[*] Please Reboot your system!!\n"
printf "[-] Exiting!\n"
esac
