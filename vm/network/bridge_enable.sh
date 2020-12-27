#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "usage: $0 <interface>"
    exit 1
fi

IF=$1

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward > /dev/null
sudo iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o $IF -j MASQUERADE 
