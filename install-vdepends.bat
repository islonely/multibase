WHERE git
IF %ERRORLEVEL% NEQ 0 echo "Git command not found. Exiting..." && exit

git clone https://github.com/islonely/base58 ./modules/base58
git clone https://github.com/islonely/base36 ./modules/base36
git clone https://github.com/islonely/base32 ./modules/base32
git clone https://github.com/islonely/v-hex ./modules/hex