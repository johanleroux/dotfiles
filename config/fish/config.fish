if status is-interactive
    # Commands to run in interactive sessions can go here
    thefuck --alias | source
end

# set -x (gnome-keyring-daemon --start | string split "=")
export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
