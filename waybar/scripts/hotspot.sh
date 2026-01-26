#!/bin/bash

INTERFACE_WIFI="wlan0"
INTERFACE_NET="enp0s20f0u2u1"
SSID="AMBHI-Arch"
PASS="lokendra"

# --- Hotspot Management Logic ---

# 1. Check for the running PID
PID=$(pgrep -f "create_ap .* $INTERFACE_WIFI $INTERFACE_NET $SSID")

if [ -z "$PID" ]; then
    # If not running, start the AP
    echo "Starting AP: $SSID"
    sudo create_ap --daemon "$INTERFACE_WIFI" "$INTERFACE_NET" "$SSID" "$PASS"
    ghostty -e /bin/sh -c "$HOME/.config/waybar/scripts/ap_status.sh; sleep 2" &
else
    # If running, attempt to stop cleanly
    echo "Stopping AP on $INTERFACE_WIFI (PID: $PID)"
    
    # A. First, attempt a clean stop (requires NOPASSWD sudo)
    sudo create_ap --stop "$INTERFACE_WIFI" 2>/dev/null
    
    # B. Wait briefly and check if the PID is still alive
    sleep 1 
    ghostty -e /bin/sh -c "$HOME/.config/waybar/scripts/ap_status.sh; sleep 2" &
    if pgrep -f "create_ap .* $INTERFACE_WIFI .* $SSID" > /dev/null; then
        echo "Clean stop failed. Forcibly killing PID $PID..."
        # C. If still running, force kill the PID (requires NOPASSWD sudo)
        sudo kill -9 "$PID"
        ghostty -e /bin/sh -c "$HOME/.config/waybar/scripts/ap_status.sh; sleep 2" &
    fi
fi
