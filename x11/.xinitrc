xrandr --auto
xset r rate 200 100
redshift -O 2000K 
amixer -c 1 set PCM 20%

# Accel Profile Enabled
xinput set-prop 18 321 0, 1
xinput set-prop 13 321 0, 1
exec i3
