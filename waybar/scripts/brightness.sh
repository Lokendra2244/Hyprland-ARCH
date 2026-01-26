#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────

# 1. FIND A VALID MONITOR
# We look for the first available 'ddcci' device.
# If none found, fallback to default (usually laptop screen or empty).
device=$(ls /sys/class/backlight/ | grep ddcci | head -n 1)

if [ -z "$device" ]; then
    # Fallback if no DDCCI monitor is found (prevents crash)
    current=$(brightnessctl get)
    max=$(brightnessctl max)
else
    # Use the specific DDCCI device found (e.g., ddcci5)
    current=$(brightnessctl -d "$device" get)
    max=$(brightnessctl -d "$device" max)
fi

# 2. CALCULATE PERCENTAGE
# Avoid division by zero if max is 0
if [ "$max" -eq 0 ]; then
    percent=0
else
    percent=$((current * 100 / max))
fi

# 3. ICON LOGIC
if [ "$percent" -lt 30 ]; then
    icon="󰃞 "
elif [ "$percent" -lt 70 ]; then
    icon="󰃟 "
else
    icon="󰃠 "
fi

# 4. ASCII BAR LOGIC
bar_full="▓▓▓▓▓▓▓▓▓▓"
bar_empty="░░░░░░░░░░"

if [ "$percent" -ge 100 ]; then
    ascii_bar="|$bar_full|"
elif [ "$percent" -eq 0 ]; then
    ascii_bar="|$bar_empty|"
else
    filled=$((percent / 10))
    empty=$((10 - filled))
    ascii_bar="|${bar_full:0:$filled}${bar_empty:0:$empty}|"
fi

# 5. CLASS LOGIC (for CSS)
if [ "$percent" -lt 20 ]; then
    css_class="low"
elif [ "$percent" -lt 50 ]; then
    css_class="medium"
else
    css_class="normal"
fi

# 6. TOOLTIP
# Optional: Show which device is being read in the tooltip
tooltip="Brightness: $percent%\nSource: $device"

# 7. OUTPUT
echo "{\"text\":\" [ $icon $ascii_bar] \",\"tooltip\":\"$tooltip\",\"class\":\"$css_class\"}"
