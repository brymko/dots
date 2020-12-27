#!/bin/bash


BRIDGEIF=qemubr0

sudo ip link show $BRIDGEIF 2>/dev/null 1>/dev/null
if [ $? -eq 1 ]; then
    sudo ip link add $BRIDGEIF type bridge
fi
sudo ip addr flush dev $BRIDGEIF
sudo ip addr add 10.10.10.100/24 brd 10.10.10.255 dev $BRIDGEIF

sudo ip tuntap add mode tap user "$(whoami)"
if [ $? -ne 0 ]; then
    echo "Failed to setup tap device... Aborting" 1>&2
    exit 1
fi
TAPDEV=$(ip tuntap show | tail -n 1 | cut -d ':' -f 1)

sudo dnsmasq --interface=$BRIDGEIF --bind-interfaces --dhcp-range=10.10.10.100,10.10.10.254

sudo ip link set dev $BRIDGEIF up
sudo ip link set dev "$TAPDEV" up

sudo ip link set "$TAPDEV" master $BRIDGEIF



