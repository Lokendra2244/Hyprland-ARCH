#!/bin/bash

echo "Resetting DDC/CI modules..."

# 1. Unload BOTH drivers to completely clear the sysfs state and prevent duplicate (-17) errors
sudo rmmod ddcci_backlight 2>/dev/null || true
sudo rmmod ddcci 2>/dev/null || true

# Give the kernel a moment to clean up the sysfs tree
sleep 1

# Ensure the main bus driver is awake
sudo modprobe ddcci 2>/dev/null || true

# 2. Find the active monitor bus dynamically
BUSES=$(sudo ddcutil detect 2>/dev/null | awk '/I2C bus:/ {print $NF}' | tr -d '/dev/i2c-')

# Exit early if no monitors detected
if [ -z "$BUSES" ]; then
  echo "No monitors detected via DDC — is the monitor powered on?"
  exit 1
fi

for bus in $BUSES; do
  # 3. Check if the device is ALREADY registered before forcing a new one
  # 0037 is the standard I2C hex address for DDC/CI
  if [ ! -d "/sys/bus/i2c/devices/$bus-0037" ]; then
    echo "Attaching monitor on bus $bus..."
    echo "ddcci 0x37" | sudo tee "/sys/bus/i2c/devices/i2c-$bus/new_device" >/dev/null
  else
    echo "Monitor already cleanly registered on bus $bus."
  fi
done

# 4. The critical pause: give the I2C bus time to finalize
sleep 2

# 5. Reload the backlight driver so it scans the newly attached bus
sudo modprobe ddcci_backlight

echo "Backlight driver reloaded successfully."
