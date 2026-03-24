#!/bin/bash
# This script is used to check network connectivity and display relevant information about the network status.
echo "-- Network Connectivity Check --"

#Local IPs with interface names 
echo "Local IP's:" 
hostname -I | tr ' ' '\n' | while read ip; do
    if [[ -n "$ip" ]]; then
        iface=$(ip -o addr show | grep "$ip" | awk '{print $2}')
        echo "  $iface: $ip"
    fi
done

#Public IP with timeout and error handling
echo "Public IP Timeout:"
PUBLIC_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null) 
if [ -z "$PUBLIC_IP" ]; then
    echo "Unable to fetch IP, check internet connection."
else
    echo "Public IP: $PUBLIC_IP"
fi

#Open ports and listening services
if command -v netstat &> /dev/null; then
    ss -tuln | grep LISTEN | awk '{print " " $0}'
else
    echo "netstat not found, trying netstat..."
    netstat -tuln | grep LISTEN | awk '{print " " $0}' || echo "netstat not available."
fi


#Check connectivity network availability by pinging a well-known server (Google DNS)
if ! ping -c 1 8.8.8.8 &> /dev/null; then

    echo "Network connectivity: ${RED}Unavailable${NC}"
    else
    echo "Network connectivity: ${GREEN}Available${NC}"
fi
