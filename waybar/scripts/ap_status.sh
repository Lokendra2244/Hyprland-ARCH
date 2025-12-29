#!/bin/bash

INTERFACE_WIFI="wlan0"
SSID="AMBHI-Arch"

# Check if create_ap is running with the specific SSID/interface
if pgrep -f "create_ap .* $INTERFACE_WIFI .* $SSID" > /dev/null; then
    # Output for when the AP is ON
    echo "AP: ON 🚀"
else
    # Output for when the AP is OFF
    echo "AP: OFF 📴"
fi
