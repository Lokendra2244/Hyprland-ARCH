#!/bin/bash
ncspot_id=$(pactl list sink-inputs | awk '/Sink Input/ {idx=$3} /application.name = "spotify"/ {print idx}' | tr -d '#')
if [ -n "$ncspot_id" ]; then
  if [ "$1" = "up" ]; then
    pactl set-sink-input-volume $ncspot_id +2%
  elif [ "$1" = "down" ]; then
    pactl set-sink-input-volume $ncspot_id -2%
  fi
fi
