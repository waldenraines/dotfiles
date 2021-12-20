#! /bin/sh

# check if bspwm is running:
pgrep bspwm > /dev/null || exit 0

move_desktops() {
    monitor=$1
    desktops=$2
    for desktop in "$desktops" 
    do
        echo "moving $desktop to $monitor"
        bspc desktop $desktop --to-monitor $monitor
    done
}

monitor_add() {
    # Add the external monitor
    xrandr --output eDP-1 \
        --primary --mode 1920x1080 \
        --pos 0x0 --rotate normal \
        --output DP-1 --off --output HDMI-1 --off \
        --output DP-2 --mode 1920x1080 --pos 1920x0 \
        --rotate normal --output DP-3 --off --output HDMI-2 --off
}

monitor_remove() {
    bspc monitor DP-2 --remove > /dev/null

    xrandr --output eDP-1 --primary \
        --mode 1920x1080 --pos 0x0 \
        --rotate normal --output DP-1 \
        --off --output HDMI-1 --off \
        --output DP-2 --off --output DP-3 --off \
        --output HDMI-2 --off 
}

if xrandr | grep -o "DP-2 connected" > /dev/null && [[ "$1" != "1" ]] && [[ "$(bspc query -M | wc -l)" != 2 ]]
then
    monitor_add
    desktops=("5" "6" "7" "8" "9" "0" "videos")
    move_desktops "DP-2" $desktops
else
    desktops=$(bspc query -D -m DP-2) || []
    monitor_remove
    move_desktops "eDP-1" $desktops
fi
