#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────
# Description: Shows current brightness with ASCII bar + tooltip
# Usage: Waybar `custom/brightness` every 2s
# Dependencies: brightnessctl, seq, printf, awk
#  ─────────────────────────────────────────────────────────

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$((brightness * 100 / max_brightness))

# Build ASCII bar

if [ "$percent" -eq 100 ]; then
    ascii_bar="|$(printf '▓%.0s' $(seq 1 10))|"  # 10 filled blocks
elif [ "$percent" -eq 0 ]; then
    ascii_bar="|$(printf '░%.0s' $(seq 1 10))|"  # 10 empty blocks
else
    filled=$((percent / 10))
    empty=$((10 - filled))
    ascii_bar="|$(printf '▓%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))|"
fi

# Icon
icon="󰛨"

# Color thresholds
if [ "$percent" -lt 20 ]; then
    fg="#bf616a"  # red
elif [ "$percent" -lt 55 ]; then
    fg="#000000"  # orange
else
    fg="#000000"  # cyan
fi

# Device name (first column from brightnessctl --machine-readable)
device=$(brightnessctl --machine-readable | awk -F, 'NR==1 {print $1}')

# Tooltip text
tooltip="Brightness: $percent%\nDevice: $device"

# JSON output
echo "{\"text\":\"<span foreground='$fg'> [ $icon $ascii_bar] </span>\",\"tooltip\":\"$tooltip\"}"
