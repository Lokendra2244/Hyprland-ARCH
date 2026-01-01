#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$((brightness * 100 / max_brightness))

# Device name (first column from brightnessctl --machine-readable)
device=$(brightnessctl --machine-readable | awk -F, 'NR==1 {print $1}')

# Icon
icon="󰛨"

# ASCII Bar (Fixed using String Slicing)
bar_full="▓▓▓▓▓▓▓▓▓▓"
bar_empty="░░░░░░░░░░"

# Calculate filled and empty blocks
filled=$((percent / 10))
empty=$((10 - filled))

# Handle the 100% edge case where math might give >10 if percent > 100
if [ "$filled" -gt 10 ]; then filled=10; empty=0; fi

# Slice strings to prevent the "5%" bug
ascii_bar="|${bar_full:0:$filled}${bar_empty:0:$empty}|"

# Class logic (Replaces hardcoded colors)
if [ "$percent" -lt 20 ]; then
    css_class="low"
elif [ "$percent" -lt 55 ]; then
    css_class="medium"
else
    css_class="high"
fi

# Tooltip text
tooltip="Brightness: $percent%\nDevice: $device"

# Final JSON output
echo "{\"text\":\" [ $icon $ascii_bar] \",\"tooltip\":\"$tooltip\",\"class\":\"$css_class\"}"
