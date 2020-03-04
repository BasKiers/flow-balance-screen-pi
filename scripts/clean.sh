#!/bin/sh

sudo pkill -9 -u guest
sudo deluser pi guest
sudo userdel guest
sudo rm -rf /home/guest
sudo rm -f /etc/xdg/openbox/autostart

# sudo apt-get remove chromium-browser xserver-xorg x11-xserver-utils xinit openbox

