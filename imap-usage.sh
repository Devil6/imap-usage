#!/bin/bash

read -p "Enter Domain Name : " domain
read -p "All logs? [y/n] : " alllogs
account=$(/scripts/whoowns $domain)
accPath="/home/$account"
logfile="maillog"

if [ $alllogs = "y" ]
then
    logfile="maillog*"
else
    logfile="maillog"
fi

echo "Searching /var/log/$logfile please wait..."
echo ""
echo "Results will be in the following format :"
echo "Usage"
echo "Email Address"
echo ""
echo ""
echo "This may take some time depending on log size"
echo ""

emails=($(awk -F ':' '{print $1}' /home/$account/etc/$domain/shadow))
for t in ${emails[@]}; do
    grep "$t@$domain" /var/log/$logfile | grep bytes | sed 's/imap(//g; s/).*://g' | awk '{print $6, $NF}' | sed 's/bytes=.*\///g' | awk '{SUM += $2}END {print SUM/1024/1024/1024" GB"}'
    echo "$t@$domain"
    echo ""
done
