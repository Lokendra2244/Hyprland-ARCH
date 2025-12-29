#!/bin/bash
# ── volume.sh ─────────────────────────────────────────────
# Description: Shows current audio volume with ASCII bar + tooltip
# Usage: Waybar `custom/volume` every 1s
# Dependencies: wpctl, awk, bc, seq, printf
# ───────────────────────────────────────────────────────────

# Get raw volume and convert to int
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
vol_int=$(echo "$vol_raw * 100" | bc | awk '{ print int($1) }')

# Check mute status
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

# Get default sink description (human-readable)
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

# ASCII bar

if [ "$vol_int" -ge 100 ]; then
    # Print 10 filled blocks for 100% and above
    ascii_bar="|$(printf '▓%.0s' $(seq 1 10))|"
elif [ "$vol_int" -eq 0 ]; then
    # Print 10 empty blocks for 0%
    ascii_bar="|$(printf '░%.0s' $(seq 1 10))|"
else
    filled=$((vol_int / 10))
    empty=$((10 - filled))

    ascii_bar="|$(printf '▓%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))|"
fi


# Color logic
if [ "$is_muted" = true ] || [ "$vol_int" -lt 10 ]; then
  fg="#bf616a" # red
elif [ "$vol_int" -lt 50 ]; then
  fg="#fab387" # orange
else
  fg="#000000" # cyan
fi

# Tooltip text
if [ "$is_muted" = true ]; then
  tooltip="Audio: Muted\nOutput: $sink"
else
  tooltip="Audio: $vol_int%\nOutput: $sink"
fi

# Final JSON output
echo " {\"text\":\"<span foreground='$fg'> [ $icon $ascii_bar] </span>\",\"tooltip\":\"$tooltip\"}"
