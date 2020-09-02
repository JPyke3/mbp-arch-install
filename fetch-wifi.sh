#!/bin/bash

# Installing homebrew just in case it isn't
if [ ! -f /usr/local/bin/brew ]; then
    printf "You don't have homebrew installed on your system!\n"
    printf "Homebrew is a package manager for MacOS, to proceed it needs to be installed\n"
    printf "Would you like to proceed?\n"
    read -p "[Y/n]: " input
    if [! "${input}" == "Y" ]; then
        printf "Aborting!"
        exit 1
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ ! -f /usr/local/bin/ggrep ]; then
    # Installing GNU Grep to use Perl regexp
    printf "Installing ggrep on your system\n"
    brew install grep
fi

TRX=$(/usr/sbin/ioreg -l | ggrep -oP '(?<=Firmware"=").+?(?=","TxCap)')
CLMB=$(/usr/sbin/ioreg -l | ggrep -oP '(?<=Regulatory"=").+?(?=","NVRAM)')
TXT=$(/usr/sbin/ioreg -l | ggrep -oP '(?<=NVRAM"=").+?(?="}\))')


