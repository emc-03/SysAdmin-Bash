#!/bin/bash
# This script is used to display system information in a graphical format using zenity.
INTERVAL=5
while true; do
    # Get memory usage information
    echo "Memory Usage: [$(date)] CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')% | RAM: $(free -m | awk ' /^Mem:/ {printf "%.1f%%", $3/$2*100}')"
    sleep $INTERVAL
    done
