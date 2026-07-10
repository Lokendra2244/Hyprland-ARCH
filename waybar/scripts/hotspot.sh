#!/bin/bash

INTERFACE_WIFI="wlan0"
SSID="AMBHI-Arch"
PASS="lokendra"
STATUS_SCRIPT="$HOME/.config/waybar/scripts/ap_status.sh"

# Check if the hotspot connection is currently active
if nmcli connection show --active | grep -qw "$SSID"; then

  # It is ON. Open Ghostty instantly and turn it OFF inside the window.
  ghostty -e bash -c "echo 'Stopping AP: $SSID...'; sudo nmcli connection down '$SSID'; bash '$STATUS_SCRIPT'; sleep 2" &

else

  # It is OFF. Open Ghostty instantly and turn it ON inside the window.
  ghostty -e bash -c "echo 'Starting AP: $SSID...'; echo 'Please wait, configuring radio...'; sudo nmcli device wifi hotspot ifname '$INTERFACE_WIFI' ssid '$SSID' password '$PASS' con-name '$SSID'; bash '$STATUS_SCRIPT'; sleep 2" &

fi
