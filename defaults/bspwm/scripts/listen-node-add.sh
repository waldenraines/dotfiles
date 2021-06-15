#!/usr/bin/env bash

function kill_polybar_autohide() {
  ps -x -o pid:1,cmd:1 \
    | grep 'hideIt.sh --name Polybar' \
    | grep 'bash' \
    | head -n 1 \
    | cut -f 1 -d ' ' \
    | xargs kill \
    || true
}

bspc subscribe node_add \
  | while read line; do
      [ $(wmctrl -l | wc -l) != 1 ] || kill_polybar_autohide
    done