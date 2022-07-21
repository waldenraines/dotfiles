#!/bin/bash

mapfile -t monitors < <(xrandr | sed -n "s/^\([^ ]*\) connected.*/\1/p")
number_of_monitors=${#monitors[@]}

if [ $number_of_monitors -gt 1 ]; then
	echo "Two monitors detected"

	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
		--output DP-1 --off \
		--output HDMI-1 --off \
		--output DP-2 --mode 1920x1080 --pos 1920x0 --rotate normal \
		--output DP-3 --off \
		--output HDMI-2 --off

	for monitor in "${monitors[@]}"; do
		is_primary=`xrandr | grep $monitor | grep primary`
		if [ -z "$is_primary" ]; then
			secondary_monitor=$monitor
			echo "Secondary monitor set as $secondary_monitor"
		else
			primary_monitor=$monitor
			echo "Primary monitor set as $primary_monitor"
		fi
	done

	bspc desktop "5" --to-monitor $secondary_monitor 
	bspc desktop "6" --to-monitor $secondary_monitor 
	bspc desktop "7" --to-monitor $secondary_monitor 
	bspc desktop "8" --to-monitor $secondary_monitor 
	bspc desktop "9" --to-monitor $secondary_monitor 
	bspc desktop "0" --to-monitor $secondary_monitor 
	bspc desktop "videos" --to-monitor $secondary_monitor 

else
	monitor=${monitors[0]}
	echo "One monitor detected $monitor"

	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
		--output DP-1 --off \
		--output HDMI-1 --off \
		--output DP-2 --off \
		--output DP-3 --off \
		--output HDMI-2 --off

	bspc desktop "5" --to-monitor $monitor 
	bspc desktop "6" --to-monitor $monitor 
	bspc desktop "7" --to-monitor $monitor 
	bspc desktop "8" --to-monitor $monitor 
	bspc desktop "9" --to-monitor $monitor 
	bspc desktop "0" --to-monitor $monitor 
	bspc desktop "videos" --to-monitor $monitor 
fi
