#!/usr/bin/env bash

# Check if the user can run sudo without a passowrd
if sudo -n true 2>/dev/null; then
  echo "User $(whoami) has sudo privileges."
else
  if sudo -v; then
    echo "Sudo access granted."
  else
    echo "Failed to obtain sudo privileges."
    exit 1
  fi
fi

# Install all packages
bash ./install.sh

# LightDM
if ! systemctl is-enabled --quiet lightdm; then
  echo "Enabling LightDM service"
  sudo systemctl enable lightdm
fi

# Check if autologin group does not exist
if ! getent group autologin >/dev/null 2>&1; then
  echo "Creating 'autologin' group."
  sudo groupadd -r autologin
fi
# Add user to autologin group if not already a member
if ! id -nG "$(whoami)" | grep -qw "autologin"; then
  echo "Adding $(whoami) to the autologin group"
  sudo gpasswd -a $USER autologin
fi
# Configure LightDM for autologin
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"
if ! grep -q "autologin-user=$(whoami)" "$LIGHTDM_CONF"; then
  echo "Configuring LightDM for autologin"

  # Replace #autologin-user= with autologin-user=$(whoami)
  sudo sed -i "s/#autologin-user=.*/autologin-user=$(whoami)/" "$LIGHTDM_CONF"
fi

# Bluetooth
if ! systemctl is-enabled --quiet bluetooth; then
  echo "Enabling bluetooth service"
  sudo systemctl enable bluetooth
fi
if ! systemctl is-active --quiet bluetooth; then
  echo "Enabling bluetooth service"
  sudo systemctl start bluetooth
fi

# Docker
if ! systemctl is-enabled --quiet docker; then
  echo "Enabling docker service"
  sudo systemctl enable docker.socket
fi
if ! id -nG "$(whoami)" | grep -qw "docker"; then
  echo "Adding $(whoami) to the Docker group"
  sudo usermod -aG docker $USER
fi

# Valkey
if ! systemctl is-enabled --quiet valkey; then
  echo "Enabling valkey service"
  sudo systemctl enable valkey
fi
if ! systemctl is-active --quiet valkey; then
  echo "Starting Valkey service"
  sudo systemctl start valkey
fi

# Syncthing
if ! systemctl is-enabled --user --quiet syncthing; then
  echo "Enabling Syncthing service"
  systemctl --user enable syncthing
fi
if ! systemctl is-active --user --quiet syncthing; then
  echo "Starting Syncthing service"
  systemctl --user start syncthing
fi

# nvm
if ! [ -d "$HOME/.nvm" ]; then
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  nvm install --lts
  nvm use --lts
fi

# bat
bat cache --build

# Stow dotfiles and scripts
bash ./stow.sh

# Copy .wallpaper directory to $HOME
echo "Copy .wallpaper directory to $HOME"
cp -r wallpaper/.wallpaper $HOME/.wallpaper

# Snapper setup
if ! sudo snapper list-configs 2>/dev/null | grep -q "root"; then
  sudo snapper -c root create-config /
fi

if ! sudo snapper list-configs 2>/dev/null | grep -q "home"; then
  sudo snapper -c home create-config /home
fi

# Tweak default Snapper configs
sudo sed -i 's/^TIMELINE_CREATE="yes"/TIMELINE_CREATE="no"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^NUMBER_LIMIT="50"/NUMBER_LIMIT="5"/' /etc/snapper/configs/{root,home}
sudo sed -i 's/^NUMBER_LIMIT_IMPORTANT="10"/NUMBER_LIMIT_IMPORTANT="5"/' /etc/snapper/configs/{root,home}

# Limine Snapper Sync
if ! sudo systemctl is-enabled --quiet limine-snapper-sync.service; then
  echo "Enabling limine-snapper-sync service"
  sudo systemctl enable limine-snapper-sync.service
fi

# Tailscale
if ! sudo systemctl is-enabled --quiet tailscaled; then
  echo "Enabling Tailscale service"
  sudo systemctl enable --now tailscaled
fi

if ! sudo systemctl is-active --quiet tailscaled; then
  echo "Starting Tailscale service"
  sudo systemctl start tailscaled
  sudo tailscale set --operator=$USER
fi

# Set the default shell
CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)
ZSH_PATH=$(command -v zsh)

if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
  if chsh -s "$ZSH_PATH"; then
    echo "Default shell changed to zsh. You need to log out for the change to take effect"
  else
    echo "Failed to change the default shell to zsh"
  fi
fi

echo "✅ Setup completed!"

echo "Please restart your computer to ensure all changes take effect."
echo "Restart now? (y/n)"
read -r answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  sudo reboot now
fi
