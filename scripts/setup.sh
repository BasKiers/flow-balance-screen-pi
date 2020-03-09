#!/bin/sh

DEBUG_MODE=true
SCRIPT_DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )

echo "CLEANING"
$SCRIPT_DIR/clean.sh

echo "SET DEFAULT USER"


echo "SETUP"
SCREEN_ID=$(cat /sys/class/net/eth0/address | /usr/bin/md5sum | cut -f1 -d" ")

sudo adduser guest --gecos "guest guest, 10, 12, 12" --disabled-password
sudo mkdir /home/guest
sudo chown guest:guest /home/guest
sudo usermod -aG guest pi

sudo cp $SCRIPT_DIR/.xinitrc /home/guest/.xinitrc
sudo cp $SCRIPT_DIR/.bash_profile /home/guest/.bash_profile
echo "export SCREEN_ID=$SCREEN_ID" | sudo tee -a /home/guest/.bash_profile
echo "$SCREEN_ID" | sudo tee /home/guest/.screen_id

sudo service dnsmasq stop
sudo apt-get update
sudo apt-get install -y --no-install-recommends chromium-browser xserver-xorg x11-xserver-utils xinit openbox dnsmasq

sudo cp $SCRIPT_DIR/dnsmasq.conf /etc/dnsmasq.conf
sudo service dnsmasq start

sudo chown guest:guest /home/guest/.screen_id /home/guest/.xinitrc /home/guest/.bash_profile
sudo chmod -R o-rwx /home/pi /home/guest
sudo chmod ugo-w /home/guest/.xinitrc /home/guest/.bash_profile /home/guest/.bashrc /home/guest/.bash_logout /home/guest/.screen_id /home/guest/.profile

if DEBUG_MODE
then
  echo "pi:foobar" | sudo chpasswd
else
  # Disable usb
  echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
fi

# Add cron tasks
# Nightly restart
crontab -l | grep -v /sbin/shutdown | { cat; echo "0 3 * * * /sbin/shutdown -r +5"; } | crontab -
# Ping NewRelic for uptime event
crontab -l | grep -v uptime.sh | { cat; echo "* * * * * $SCRIPT_DIR/uptime.sh"; } | crontab -
