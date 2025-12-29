#!/bin/bash

cava | while read -r line; do
  bars=(${line//;/ })
  bar_line=""
  for n in "${bars[@]}"; do
    case $n in
      0) bar_line+="▁" ;;
      1) bar_line+="▂" ;;
      2) bar_line+="▃" ;;
      3) bar_line+="▄" ;;
      4) bar_line+="▅" ;;
      5) bar_line+="▆" ;;
      6|7|8|9|10) bar_line+="▇" ;;
      *) bar_line+="█" ;;
    esac
  done
  echo "{\"text\": \"$bar_line\", \"tooltip\": \"Audio Visualizer\"}"
done
