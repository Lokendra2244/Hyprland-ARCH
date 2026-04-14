#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────

# 1. FIND A VALID MONITOR
device=$(ls -1 /sys/class/backlight/ 2>/dev/null | grep '^ddcci' | head -n 1)

if [ -z "$device" ]; then
  # Fallback if no DDCCI monitor is found
  current=$(brightnessctl get 2>/dev/null || echo 0)
  max=$(brightnessctl max 2>/dev/null || echo 100)
else
  # DIRECT READ
  current=$(cat "/sys/class/backlight/$device/actual_brightness" 2>/dev/null || cat "/sys/class/backlight/$device/brightness" 2>/dev/null || echo 0)
  max=$(cat "/sys/class/backlight/$device/max_brightness" 2>/dev/null || echo 100)
fi

# Failsafe: Ensure variables are never empty so bash math doesn't crash
current=${current:-0}
max=${max:-100}

# 2. CALCULATE PERCENTAGE
# Avoid division by zero
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
elif [ "$percent" -le 0 ]; then
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
tooltip="Brightness: $percent%\nSource: ${device:-fallback}"

# 7. OUTPUT
echo "{\"text\":\" [$icon$ascii_bar] \",\"tooltip\":\"$tooltip\",\"class\":\"$css_class\"}"
