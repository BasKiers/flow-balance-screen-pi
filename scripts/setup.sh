#!/bin/sh

SCRIPT_DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )

echo "CLEANING"
$SCRIPT_DIR/clean.sh

echo "SET DEFAULT USER"


echo "SETUP"

sudo adduser guest --gecos "guest guest, 10, 12, 12" --disabled-password
#sudo useradd -m -d /home/guest/ -s /bin/bash -G guest
echo "guest:foobar" | sudo chpasswd
sudo mkdir /home/guest
sudo chown guest:guest /home/guest
sudo chmod g+w /home/guest
sudo chmod o-rwx /home/*
sudo usermod -aG guest pi

sudo touch /home/guest/.screen_id
sudo cat /sys/class/net/eth0/address | /usr/bin/md5sum | cut -f1 -d" " > /home/guest/.screen_id
sudo chown guest:guest /home/guest/.sreen_id
sudo cp $SCRIPT_DIR/.xinitrc /home/guest/.xinitrc
sudo cp $SCRIPT_DIR/.bash_profile /home/guest/.bash_profile
chown guest:guest /home/guest/.xinitrc
chown guest:guest /home/guest/.bash_profile

sudo apt-get update
sudo apt-get install -y --no-install-recommends chromium-browser xserver-xorg x11-xserver-utils xinit openbox

