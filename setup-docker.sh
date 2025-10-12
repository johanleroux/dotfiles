#!/usr/bin/env bash

echo "add your user to the docker group"
sudo usermod -aG docker $USER
