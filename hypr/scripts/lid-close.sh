#!/bin/bash
count=$(hyprctl monitors -j | grep -c '"disabled": false')
if [ "$count" -ge 2 ]; then
  hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
fi
