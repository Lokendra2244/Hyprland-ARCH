#!/bin/bash
# ── battery.sh ─────────────────────────────────────────────

capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

# Get detailed info
time_to_empty=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk -F: '/time to empty/ {print $2}' | xargs)
time_to_full=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk -F: '/time to full/ {print $2}' | xargs)

# Icons
charging_icons=(󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)
default_icons=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)

index=$((capacity / 10))
[ $index -ge 10 ] && index=9

if [[ "$status" == "Charging" ]]; then
    icon=${charging_icons[$index]}
elif [[ "$status" == "Full" ]]; then
    icon="󰂅"
else
    icon=${default_icons[$index]}
fi

# ASCII Bar (Fixed using String Slicing)
bar_full="▓▓▓▓▓▓▓▓▓▓"
bar_empty="░░░░░░░░░░"

if [ "$capacity" -ge 100 ]; then
    ascii_bar="|$bar_full|"
elif [ "$capacity" -eq 0 ]; then
    ascii_bar="|$bar_empty|"
else
    filled=$((capacity / 10))
    empty=$((10 - filled))
    # Slice strings to prevent the "5%" bug
    ascii_bar="|${bar_full:0:$filled}${bar_empty:0:$empty}|"
fi

# Class logic (Replaces hardcoded colors)
if [ "$status" == "Charging" ]; then
    css_class="charging"
elif [ "$capacity" -lt 20 ]; then
    css_class="critical"
elif [ "$capacity" -lt 55 ]; then
    css_class="warning"
else
    css_class="normal"
fi

# Tooltip text
if [[ "$status" == "Charging" ]]; then
    tooltip="Fuel: $capacity%\nStatus: Charging\nFull in: $time_to_full"
elif [[ "$status" == "Discharging" ]]; then
    tooltip="Fuel: $capacity%\nStatus: Discharging\nEmpty in: $time_to_empty"
else
    tooltip="Fuel: $capacity%\nStatus: $status"
fi

# Final JSON output
echo "{\"text\":\" [ $icon $ascii_bar] \",\"tooltip\":\"$tooltip\",\"class\":\"$css_class\"}"
