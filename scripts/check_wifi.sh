#!/bin/bash
#=================================================================
# Script Variables Settings
clear
wlan='wlan0'
gateway='8.8.8.8'
retries=12
#=================================================================
echo " - Auto Reconnect Wi-Fi Status for $wlan Script Started ";

# Only send two pings, sending output to /dev/null as we don't want to fill logs on our sd card.
ping -I ${wlan} -c2 ${gateway} > /dev/null # ping to gateway from Wi-Fi

# If the return code from ping ($?) is not 0 (meaning there was an error)
if [ $? != 0 ]
then
  # Restart the wireless interface
  sudo ifconfig $wlan down
  sudo ifconfig $wlan up
  sleep 5
  for i in {1..$retries}
  do
    ping -I ${wlan} -c2 ${gateway} > /dev/null # ping to gateway from Wi-Fi
    if [ $? == 0 ]
    then
      pkill -9 -u guest
      break
    else
      if [ $i == $retries ]
      then
          sudo reboot
      fi
    fi
    sleep 5
    sudo ifconfig $wlan up
  done
fi
date
echo " - Auto Reconnect Wi-Fi Status for $wlan Script Ended ";
