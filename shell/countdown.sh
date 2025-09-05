#!/bin/bash
set -euo pipefail

# Countdown script for macOS Terminal

# Get number of minutes from the first argument or default to 20
minutes=${1:-20}
total_seconds=$((minutes * 60))

# Function to format seconds as MM:SS
format_time() {
  printf "%02d:%02d" $(( $1 / 60 )) $(( $1 % 60 ))
}

# Countdown loop
while [ $total_seconds -gt 0 ]; do
  printf "\r%s" "$(format_time $total_seconds)"
  sleep 1
  total_seconds=$((total_seconds - 1))
done

# Done message
printf "\rTime's up! 🎉\n"

# Play a sound when the alarm goes off
osascript -e 'beep 3'
osascript -e 'tell app "System Events" to display dialog "Time is up! 🎉" with title "Alarm"'
