#!/bin/bash

# Source pywal's tty color script (sets ANSI colors in terminal)
source "$HOME/.cache/wal/colors-tty.sh"

# Launch tty-clock in a ghostty window using pywal colors
ghostty -e tty-clock -c
