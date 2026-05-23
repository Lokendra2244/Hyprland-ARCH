#!/bin/bash

# 1. Unload the backlight driver so it releases any stale state
sudo rmmod ddcci_backlight 2>/dev/null || true

# Ensure the main bus driver is awake
sudo modprobe ddcci 2>/dev/null || true

# 2. Find the active monitor bus dynamically
BUSES=$(sudo ddcutil detect 2>/dev/null | awk '/I2C bus:/ {print $NF}' | tr -d '/dev/i2c-')

# Exit early if no monitors detected (e.g. monitor is powered off)
if [ -z "$BUSES" ]; then
    echo "No monitors detected via DDC — is the monitor powered on?"
    exit 1
fi

for bus in $BUSES; do
  # 3. Clear the bus just in case
  echo 0x37 | sudo tee "/sys/bus/i2c/devices/i2c-$bus/delete_device" >/dev/null 2>&1 || true

  # 4. Attach the monitor (Errors left visible on purpose for future debugging)
  echo "ddcci 0x37" | sudo tee "/sys/bus/i2c/devices/i2c-$bus/new_device"
done

# 5. The critical pause: give the I2C bus time to actually register the device
sleep 2

# 6. Reload the backlight driver so it scans the newly attached bus
sudo modprobe ddcci_backlight
