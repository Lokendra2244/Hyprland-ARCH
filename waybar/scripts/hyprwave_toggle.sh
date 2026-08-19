#!/bin/bash

# Check if hyprwave is running
if pgrep -x "hyprwave" >/dev/null; then
  # If running, kill it
  pkill hyprwave
else
  # If not running, start it in the background
  # (nohup and & ensure it keeps running if you close the terminal)
  nohup hyprwave >/dev/null 2>&1 &
fi
