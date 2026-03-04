#! /bin/bash

if pgrep -x "sunsetr" >/dev/null; then
  killall sunsetr
else
  sunsetr -b
fi
