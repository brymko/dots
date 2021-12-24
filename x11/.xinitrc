#!/bin/bash

xrandr --auto
xset r rate 200 120
redshift -x
redshift -O 2000K 

# run startup scripts
xscripts="$HOME/.config/x11"
if [ -d "$xscripts" ]; then
    for f in $xscripts/?*.sh ; do
        [ -x "$f" ] && "$f" 
    done
    unset f
fi

bash /home/brymko/.screenlayout/home.conf.sh
bluetoothctl power on
bluetoothctl connect E7:67:B1:69:C9:9E
xmodmap "$HOME/.config/x11/Xmodmap"
exec i3
