#!/bin/bash
# Wrapper to control ALL ddcci monitors with brightnessctl

if [ -z "$1" ]; then
    echo "Usage: $(basename "$0") <value>"
    echo "Example: $(basename "$0") +10%"
    exit 1
fi

# Find all ddcci devices
for sys_path in /sys/class/backlight/ddcci*; do
    # Extract device name (e.g., ddcci5)
    dev_name=$(basename "$sys_path")
    
    # Run sequentially (removed the & symbol)
    brightnessctl -d "$dev_name" set "$1" -q
done
