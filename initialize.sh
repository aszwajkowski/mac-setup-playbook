#!/bin/bash

echo "Install XCode"
xcode-select --install

echo "Export Python apps location to PATH"
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"

echo "Update Pip"
sudo pip3 install --upgrade pip

echo "Install Ansible"
pip3 install ansible
