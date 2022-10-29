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
    xrandr --output eDP1 \
        --primary --mode 1920x1080 \
        --pos 0x0 --rotate normal \
        --output DP1 --off --output HDMI1 --off \
        --output DP2 --mode 1920x1080 --pos 1920x0 \
        --rotate normal --output DP3 --off --output HDMI2 --off
}

monitor_remove() {
    bspc monitor DP2 --remove > /dev/null

    xrandr --output eDP1 --primary \
        --mode 1920x1080 --pos 0x0 \
        --rotate normal --output DP1 \
        --off --output HDMI-1 --off \
        --output DP2 --off --output DP3 --off \
        --output HDMI-2 --off 
}

if xrandr | grep -o "DP2 connected" > /dev/null && [[ "$1" != "1" ]] && [[ "$(bspc query -M | wc -l)" != 2 ]]
then
    monitor_add
    desktops=("5" "6" "7" "8" "9" "0" "videos")
    move_desktops "DP2" $desktops
else
    desktops=$(bspc query -D -m DP2) || []
    monitor_remove
    move_desktops "eDP1" $desktops
fi
