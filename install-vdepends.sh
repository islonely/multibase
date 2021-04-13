#!/bin/bash
if ! command -v git &> /dev/null
then
    read -p "Git command not found. Would you like to install git? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =! ^[Yy]$ ]]
    then
        exit 1
    fi
    if command -v apt &> /dev/null
    then
        sudo apt install -y git
    elif command -v dnf &> /dev/null
    then
        sudo dnf install git -y
    elif command -v pacman &> /dev/null
    then
        sudo pacman -S git
    else
        echo "Checked for apt, pacman, and yum package managers. None found; exiting..."
        exit 1
    fi
fi

git clone https://github.com/islonely/base58 ./modules/base58
git clone https://github.com/islonely/base36 ./modules/base36
git clone https://github.com/islonely/base32 ./modules/base32
git clone https://github.com/islonely/v-hex ./modules/hex