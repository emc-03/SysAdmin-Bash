#!/bin/bash
#Displays CPU, RAM, Disk Usage, and OS information in a user-friendly format.
echo "== System Display Information =="
echo "Hostname: $(hostname)"
echo "OS: $(uname -o)"
echo "Kernel Version : $(uname -r)"
echo "CPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
echo "Total Memory: $(free -h | grep 'Mem' | awk '{print $2}')"
echo "Uptime: $(uptime -p)"
echo "Disk Usage: $(df -h / | tail -1 | awk '{print $5}') used of $(df -h / | tail -1 | awk  'NR==2 '{print $3 "/" $2}')')"
