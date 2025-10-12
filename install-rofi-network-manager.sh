#!/usr/bin/env bash

git clone --depth 1 --branch master https://github.com/P3rf/rofi-network-manager.git
cd rofi-network-manager
./src/ronema
./setup.sh install
