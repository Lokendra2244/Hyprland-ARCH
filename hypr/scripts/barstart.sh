#!/bin/bash

# --- 1. KILL PHASE ---
AUTOHIDE_PID=$(ps -ef | grep "[w]aybar-autohide" | awk '{print $2}')
if [ -n "$AUTOHIDE_PID" ]; then
  kill "$AUTOHIDE_PID"
fi

if pgrep waybar >/dev/null; then
  killall waybar
  pkill -f gappname.sh
  pkill -f visualizer.sh
  killall cava
  sleep 0.5
fi

# --- 2. START PHASE ---
waybar &
waybar-autohide &
