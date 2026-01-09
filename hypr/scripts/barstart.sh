#!/bin/bash

# 1. Kill running waybar (Toggle)
if pgrep -x "waybar" > /dev/null; then
    echo "Stopping Waybar..."
    killall waybar
    pkill -f gappname.sh
    pkill -f visualizer.sh
    killall cava
    exit 0
fi

# 2. Detect Desktop (Convert to lowercase automatically)
# ${var,,} converts the variable to lowercase (Bash 4.0+)
desktop="${XDG_CURRENT_DESKTOP,,}"
echo "Detected Desktop: $desktop"

# 3. Select Config File
config_file=""

if [[ "$desktop" == *"hyprland"* ]]; then
    # Try the specific config first, fall back to default if missing
    if [ -f "$HOME/.config/waybar/config-hypr.jsonc" ]; then
        config_file="$HOME/.config/waybar/config-hypr.jsonc"
    fi

elif [[ "$desktop" == *"niri"* ]]; then
    config_file="$HOME/.config/waybar/niri-config.jsonc"
fi

# 4. Check if config exists before launching
if [ -z "$config_file" ]; then
    echo "ERROR: Could not determine config file for desktop '$desktop'"
    exit 1
fi

if [ ! -f "$config_file" ]; then
    echo "ERROR: Config file not found at: $config_file"
    exit 1
fi

echo "Launching Waybar with: $config_file"

# 5. Launch
# We remove nohup temporarily so you can see if errors happen immediately
waybar -c "$config_file" >/dev/null 2>&1 &
