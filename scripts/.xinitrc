#!/bin/sh

# disable blank screen
xset s off
xset -dpms
xset s noblank

# allow quiting the X server with CTRL-ALT-BACKSPACE
setxkbmap -option terminate:ctrl_alt_bksp

# hide mouse cursor when it's not moving
unclutter -idle 0.1 &

# get url with unique ID
URL="https://wilbur-schiphol-signing.web.app/?id=$(cat /home/guest/.screen_id)"

# launch browser
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences
chromium-browser --disable-infobars --incognito --kiosk --window-size=10000,10000 "$URL"
# --window-position=0,0

