#!/bin/bash

echo "enabling syncthing on user level"
systemctl --user enable syncthing

echo "starting syncthing"
systemctl --user start syncthing

systemctl --user status syncthing
