#!/bin/bash

if [ "$1" = "--base-ip" ]; then
    shift 1
    echo looking for BOSMiner machines with supplied base IP address of $1
    if [ -z "$1" ]; then
        echo "no base ip address supplied... quitting"
        exit
    fi
    baseip=$1
elif [ "$1" = "--my-base-address" ]; then
    # GET YOUR IP ADDRESS(es)... then the first one from the list (assume it is primary)
    # https://stackoverflow.com/questions/13322485/how-to-get-the-primary-ip-address-of-the-local-machine-on-linux-and-os-x
    yourip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n 1)

    echo your ip address is $yourip

    # REMOVE LAST OCTAL
    # https://stackoverflow.com/questions/26633623/remove-all-text-from-last-dot-in-bash
    baseip=$(echo $yourip | sed 's/\.[^.]*$//')
    echo looking for BOSMiner machines with base IP address of $baseip
else
# if you ran this script but didn't give any arguments, or the arguments were not caught above
# if [ -z "$1" ]; then
echo
echo "this script loops through IP addresses in order to find any machines running Braiins OS"
echo 
echo "usage:"
echo
echo "   sh $0 [ --base-ip BASE_IP_ADDRESS ]"
echo
echo "example:"
echo
echo "   sh $0 --base-ip 192.168.4"
echo
echo "or, use the base address of the machine running this script with:"
echo
echo "    sh $0 --my-base-address"
exit
fi

# https://stackoverflow.com/questions/30812197/bash-for-loop-for-ip-range-excluding-certain-ips
for ip in $baseip.{0..255}
do
    res=$(echo {\"command\":\"version\"} | nc -G 1 $ip 4028)
    # https://stackoverflow.com/questions/13509508/check-if-string-is-neither-empty-nor-space-in-shell-script
    if [ ! -z "$res" ]; then
        vline=$(echo $res | jq -r '.VERSION[0] .BOSminer')
        if [ ! -z "$vline" ]; then
            vapi=$(echo $res | jq -r '.VERSION[0] .API')
            echo "FOUND: $ip $vline (API: $vapi)"
        fi
    else
        echo "No miner found at IP address: $ip"
    fi
    sleep 1
done
