#!/bin/bash
if hyprshade current | grep -q "blue-light-filter"; then
    hyprshade off
    notify-send -t 1000 "Hyprshade" "Filter: OFF"
else
    hyprshade on blue-light-filter
    notify-send -t 1000 "Hyprshade" "Filter: ON"
fi
