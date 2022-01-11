#!/bin/bash

# devids=$(xinput list | grep "Logitech MX Master 3" | sd ".*id=(\d+).*$" '$1')
# while IFS= read -r did; do
#     fieldid=$(xinput list-props "$did" | grep "libinput Accel Profile Enabled" | sd ".*\((\d+)\).*" '$1')
#     while IFS= read -r fid; do
#         xinput set-prop "$did" "$fid" 0, 1 >/dev/null 2>&1
#     done <<< "$fieldid"
# done <<< "$devids"
# exit 0


# store persistent
#
# in /etc/X11/xorg.conf.d/99-libinput-custom-config.conf

# Section "InputClass"
#   Identifier "NoAccel"
#   MatchDriver "libinput"
#   MatchIsPointer "yes"
#   Option "AccelProfile" "flat"
#   Option "AccelSpeed" "1.0"
# EndSection 
