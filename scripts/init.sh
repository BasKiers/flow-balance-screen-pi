#!/bin/sh

SCRIPT_DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )

# Add git pull script to systemd startup
UPDATE_PATH=/etc/systemd/system/update_script.service
rm -f $UPDATE_PATH
touch $UPDATE_PATH
sudo chmod u+x $UPDATE_PATH

echo "[Unit]" >> $UPDATE_PATH
echo "Description=Update guest user scripts" >> $UPDATE_PATH
echo "After=network-online.target" >> $UPDATE_PATH
echo "Wants=network-online.target" >> $UPDATE_PATH
echo "Before=setup_guest.service" >> $UPDATE_PATH
echo "" >> $UPDATE_PATH

echo "[Service]" >> $UPDATE_PATH
echo "Type=oneshot" >> $UPDATE_PATH
echo "User=pi" >> $UPDATE_PATH
echo "ExecStart=$SCRIPT_DIR/update.sh" >> $UPDATE_PATH
echo "" >> $UPDATE_PATH

echo "[Install]" >> $UPDATE_PATH
echo "WantedBy=multi-user.target" >> $UPDATE_PATH

# Add setup script to systemd startup
SETUP_PATH=/etc/systemd/system/setup_guest.service
rm -f $SETUP_PATH
touch $SETUP_PATH
sudo chmod u+x $SETUP_PATH

echo "[Unit]" >> $SETUP_PATH
echo "Description=Setup guest user" >> $SETUP_PATH
echo "After=network-online.target" >> $SETUP_PATH
echo "Wants=network-online.target" >> $SETUP_PATH
echo "Before=getty@tty1.service" >> $SETUP_PATH
echo "" >> $SETUP_PATH

echo "[Service]" >> $SETUP_PATH
echo "Type=oneshot" >> $SETUP_PATH
echo "User=pi" >> $SETUP_PATH
echo "ExecStart=$SCRIPT_DIR/setup.sh" >> $SETUP_PATH
echo "" >> $SETUP_PATH

echo "[Install]" >> $SETUP_PATH
echo "WantedBy=multi-user.target" >> $SETUP_PATH

# Add autologin script to systemd
AUTOLOGIN_PATH=/etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f $AUTOLOGIN_PATH
touch $AUTOLOGIN_PATH

echo "[Service]" >> $AUTOLOGIN_PATH
echo "ExecStart=" >> $AUTOLOGIN_PATH
echo "ExecStart=/sbin/agetty --autologin guest --noclear %I $TERM" >> $AUTOLOGIN_PATH

sudo systemctl daemon-reload
sudo systemctl enable setup_guest
sudo systemctl enable update_script
sudo systemctl enable getty@.service

# Add default setting overrides
sudo sed -i 's/#disable_overscan=1/disable_overscan=1/' /boot/config.txt
sudo sed -i 's/console=tty1/console=tty3/' /boot/cmdline.txt
sudo sed -i 's/ quiet splash loglevel=0 logo.nologo vt.global_cursor_default=0//' /boot/cmdline.txt
echo -n " quiet splash loglevel=0 logo.nologo vt.global_cursor_default=0" >> /boot/cmdline.txt
sudo sed -i ':a;N;$!ba;s/\n//g' /boot/cmdline.txt

echo "Please enter passphrase"
read passphrase
sudo gpg --batch --passphrase $passphrase --yes --no-symkey-cache -o /etc/wpa_supplicant/wpa_supplicant.conf --decrypt $SCRIPT_DIR/wpa_supplicant.conf.gpg
sudo gpg --batch --passphrase $passphrase --yes --no-symkey-cache -o $SCRIPT_DIR/new_relic_key --decrypt $SCRIPT_DIR/new_relic_key.gpg
sudo chmod o-rwx /etc/wpa_supplicant/
sudo chown pi:pi $SCRIPT_DIR/new_relic_key

# Remove option to login on pi account
passwd -l pi
