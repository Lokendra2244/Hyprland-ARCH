#!/bin/bash

# Buses identified from your ddcutil output
BUSES=("5" "9")

for bus in "${BUSES[@]}"; do
    # 1. CLEANUP: Try to remove the device first.
    # This fixes the "Resource Busy" error on Bus 9.
    # We hide errors (> /dev/null) because Bus 5 might not be attached yet (the "No such file" error you saw).
    echo 0x37 | sudo tee "/sys/bus/i2c/devices/i2c-$bus/delete_device" > /dev/null 2>&1 || true

    # 2. ATTACH: Force the driver to attach
    echo "ddcci 0x37" | sudo tee "/sys/bus/i2c/devices/i2c-$bus/new_device" > /dev/null 2>&1
done
