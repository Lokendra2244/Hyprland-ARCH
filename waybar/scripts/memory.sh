#!/bin/bash
# ── memory.sh ─────────────────────────────────────────────

# 1. Get raw memory data (in kilobytes for accuracy)
mem_info=$(free | grep Mem)
total=$(echo "$mem_info" | awk '{print $2}')
used=$(echo "$mem_info" | awk '{print $3}')

# 2. Calculate Percentage (Bash integer math)
percent=$((100 * used / total))

# 3. Icon (Memory stick icon)
icon=""

# 4. ASCII Bar Logic
bar_full="▓▓▓▓▓▓▓▓▓▓"
bar_empty="░░░░░░░░░░"
filled=$((percent / 10))

# Cap at 10 to prevent errors
if [ "$filled" -gt 10 ]; then filled=10; fi
empty=$((10 - filled))

ascii_bar="|${bar_full:0:$filled}${bar_empty:0:$empty}|"

# 5. Class Logic (Colors)
if [ "$percent" -ge 80 ]; then
  css="critical" # Red if RAM is full
elif [ "$percent" -ge 50 ]; then
  css="warning" # Orange/Yellow if getting busy
else
  css="normal"
fi

# 6. Tooltip (Get human readable values like '16Gi')
human_used=$(free -h | grep Mem | awk '{print $3}')
human_total=$(free -h | grep Mem | awk '{print $2}')

# 7. Output
echo "{\"text\":\" [$icon $ascii_bar] \",\"tooltip\":\"RAM Usage: $percent%\nUsed: $human_used / $human_total\",\"class\":\"$css\"}"
