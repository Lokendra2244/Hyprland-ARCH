#!/bin/bash

# --- 1. KILL PHASE ---

# Find and kill the waybar-autohide script using ps -ef
AUTOHIDE_PID=$(ps -ef | grep "[w]aybar-autohide" | awk '{print $2}')
if [ -n "$AUTOHIDE_PID" ]; then
  kill "$AUTOHIDE_PID"
fi

# Kill running waybar and related scripts
if pgrep waybar >/dev/null; then
  killall waybar
  pkill -f gappname.sh
  pkill -f visualizer.sh
  killall cava
  sleep 0.5
fi

# --- 2. START PHASE ---

# Start Waybar via Hyprland IPC
hyprctl dispatch exec waybar

# Start the autohide program normally
waybar-autohide
