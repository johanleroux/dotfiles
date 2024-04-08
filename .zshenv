# default apps
export EDITOR="nvim"
export VISUAL="${EDITOR}"
export TERM="kitty"
export TERMINAL="kitty"
export HISTORY_IGNORE="(ls|cd|cd ..|pwd|exit|sudo reboot|history)"

# Adds ~/.local/bin and subfolders to $PATH
if [ -d "$HOME/.local/bin" ];
  then export PATH="$PATH:$HOME/.local/bin"
fi	

# cleaning up home folder
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export LC_ALL=en_US.UTF-8
