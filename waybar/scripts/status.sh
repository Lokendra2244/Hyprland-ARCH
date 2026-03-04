#!/bin/bash

status=$(playerctl --player=spotify status 2>/dev/null)
artist=$(playerctl --player=spotify metadata artist 2>/dev/null | sed 's/&/\&amp;/g')
title=$(playerctl --player=spotify metadata title 2>/dev/null | sed 's/&/\&amp;/g')

# Icons (you can customize these)
icon_play=""    # nf-fa-play
icon_pause=""   # nf-fa-pause
icon_stopped="" # nf-fa-stop

case "$status" in
"Playing")
  echo "-$icon_play $artist-$title"
  ;;
"Paused")
  echo "-$icon_pause $artist-$title"
  ;;
"Stopped" | *)
  echo "*$icon_stopped*"
  ;;
esac
