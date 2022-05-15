# Braiins-OS-tools
Scripts to help you with mining if you're using Braiins-OS


```
this script loops through IP addresses in order to find any machines running Braiins OS

usage:

   sh miner_find.sh [ --base-ip BASE_IP_ADDRESS ]

example:

   sh miner_find.sh --base-ip 192.168.4

or, use the base address of the machine running this script with:

    sh miner_find.sh --my-base-address
```

# requirements
you need jq installed, it parses the JSON that netcat returns from querying the miner

for MacOS, first download homebrew
```
brew install jq
```

for linux, raspberry pi
```
sudo apt install jq
```
