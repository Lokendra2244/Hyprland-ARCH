#!/bin/bash
# ── volume.sh ─────────────────────────────────────────────

# Get raw volume and convert to int
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
# Handle potential floating point math and ensure integer output
vol_int=$(echo "$vol_raw * 100" | bc | awk '{ print int($1) }')

# Check mute status
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

# Get default sink description
sink=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep '\*' | cut -d'.' -f2- | sed 's/^\s*//; s/\[.*//')

# Icon logic
if [ "$is_muted" = true ]; then
  icon=""
  vol_int=0
elif [ "$vol_int" -lt 50 ]; then
  icon=""
else
  icon=""
fi

# Define the full bars once
bar_full="▓▓▓▓▓▓▓▓▓▓"
bar_empty="░░░░░░░░░░"

if [ "$vol_int" -ge 100 ]; then
  ascii_bar="|$bar_full|"
elif [ "$vol_int" -eq 0 ]; then
  ascii_bar="|$bar_empty|"
else
  # Calculate how many filled blocks we need (0-9)
  filled=$((vol_int / 10))

  # Calculate empty blocks
  empty=$((10 - filled))

  # Slice the strings: ${string:start:length}
  ascii_bar="|${bar_full:0:$filled}${bar_empty:0:$empty}|"
fi

# Class logic (Replaces hardcoded colors)
if [ "$is_muted" = true ]; then
  css_class="muted"
elif [ "$vol_int" -lt 20 ]; then
  css_class="critical"
elif [ "$vol_int" -lt 50 ]; then
  css_class="warning"
else
  css_class="normal" # This handles your >50% case
fi

# Tooltip text
if [ "$is_muted" = true ]; then
  tooltip="Audio: Muted\nOutput: $sink"
else
  tooltip="Audio: $vol_int%\nOutput: $sink"
fi

# ... existing logic ...

# Final JSON output
# Notice we added the "class" field and removed the <span foreground=...> wrapper
echo "{\"text\":\" [$icon $ascii_bar] \",\"tooltip\":\"$tooltip\",\"class\":\"$css_class\"}"
