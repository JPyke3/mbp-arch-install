#!/bin/bash
# Vars
RED='\033[0;31m'
NC='\033[0m'

# Test if aunali1's repo is there - if not, add it
if [ ! ` cat /etc/pacman.conf | grep '\[mbp\]'` ]; then
    echo -e "${RED}Adding Aunali1's Repo${NC}"
    echo -e "[mbp]\nServer = https://packages.aunali1.com/archlinux/\$repo/\$arch" >> /etc/pacman.conf
fi

# Install the kernel
echo -e "${RED}Installing the kernel and headers${NC}"
sudo pacman -S linux-mbp linux-mbp-headers dkms
echo -e "${RED}Generating mkinitcpio${NC}"
sudo mkinitcpio -p linux-mbp

# Setup systemd boot
bootctl --no-variables install
# Mask existing systemd service - Needed to prevent a kernel panic
systemctl mask systemd-boot-system-token.service

#Install yay
echo -e "${RED}Installing Yay${NC}"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
rm -rf yay
cd ..

# Install macbook12-spi-driver-dkms
echo -e "${RED}Installing spi driver dkms${NC}"
git clone https://github.com/roadrunner2/macbook12-spi-driver/tree/mbp15 /usr/src/apple-ibridge-0.1
dkms install -m apple-ibridge -v 0.1

# Install some useful stuff
echo -e "${RED}Installing some useful packages via yay${NC}"
yay -S apple-bce-dkms-git iwd 

# Configure wifi
echo -e "${RED}Configuring wifi${NC}"
systemctl enable NetworkManager.service
echo -e "[device]\nwifi-backend=iwd" > /etc/NetworkManager/NetworkManager.conf

# Configure Speakers
echo -e "${RED}Configuring Speakers${NC}"
curl -fsSL https://gist.githubusercontent.com/MCMrARM/c357291e4e5c18894bea10665dcebffb/raw/fb28a34e3f255fd4e5a9fe7ac08319165d7efe4d/91-pulseaudio-custom.rules > /usr/lib/udev/rules.d/91-pulseaudio-custom.rules
curl -fsSL https://gist.githubusercontent.com/MCMrARM/c357291e4e5c18894bea10665dcebffb/raw/fb28a34e3f255fd4e5a9fe7ac08319165d7efe4d/apple-t2.conf > /usr/share/pulseaudio/alsa-mixer/profile-sets/apple-t2.conf
curl -fsSL https://gist.githubusercontent.com/MCMrARM/c357291e4e5c18894bea10665dcebffb/raw/fb28a34e3f255fd4e5a9fe7ac08319165d7efe4d/AppleT2.conf > /usr/share/alsa/cards/AppleT2.conf

