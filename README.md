# Installation
```
Login with default credentials: pi raspberry
sudo raspi-config
2. Network Options
   Wi-Fi
   Enter any country (this will be overwritten later)
   Enter an SSID + password
   Finish
sudo apt-get update
sudo apt-get install git
git clone https://github.com/BasKiers/flow-balance-screen-pi.git
sudo ./flow-balance-screen-pi/scripts/init.sh
   [Enter wpa_supplicant passphrase]
sudo reboot
```
