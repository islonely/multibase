#!/bin/bash
if ! command -v git &> /dev/null
then
    echo "Git command not found; exiting... "
    exit 1
fi

git clone https://github.com/islonely/base58 ./modules/base58
git clone https://github.com/islonely/base36 ./modules/base36
git clone https://github.com/islonely/base32 ./modules/base32
git clone https://github.com/islonely/v-hex ./modules/hex