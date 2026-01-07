#!/usr/bin/env bash

echo "Configuring Git..."

# Check if user name has not been set
git_name=$(git config --global user.name || echo "")
if [ -z "$git_name" ]; then
  read -p "Enter your name: " git_name
  git config --global user.name "$git_name"
fi

# Check if user email has not been set
git_email=$(git config --global user.email || echo "")
if [ -z "$git_email" ]; then
  read -p "Enter your email: " git_email
  git config --global user.email "$git_email"
fi
