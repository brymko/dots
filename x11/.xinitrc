#!/bin/bash

xrandr --auto
xset r rate 200 130
redshift -O 2000K 

# run startup scripts
xscripts="$HOME/.config/x11"
if [ -d "$xscripts" ]; then
    for f in "$xscripts/?*.sh" ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xmodmap "$HOME/.config/x11/.Xmodmap"
exec i3
