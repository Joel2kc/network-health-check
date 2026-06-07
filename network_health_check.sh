#!/bin/bash

REPORT="network_report.txt"
> $REPORT

log() {
    echo "$1" | tee -a $REPORT
}

log "========================================"
log "       Network Health Check Report      "
log "========================================"
log ""

log "SERVER INFORMATION"
log "Hostname    : $(hostname)"
log "Current User: $(whoami)"
log "Date & Time : $(date)"
log ""

log "NETWORK INFORMATION"
IP=$(hostname -I | awk '{print $1}')
GW=$(ip route | grep default | awk '{print $3}')
DNS=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | head -1)

log "IP Address      : $IP"
log "Default Gateway : $GW"
log "DNS Server      : $DNS"
log ""

log "INTERNET CONNECTIVITY"
ping -c 3 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log "Internet Connectivity: UP"
else
    log "Internet Connectivity: DOWN"
fi
log ""

log "DNS RESOLUTION"
nslookup google.com > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log "DNS Resolution: WORKING"
else
    log "DNS Resolution: FAILED"
fi
log ""

log "WEBSITE AVAILABILITY"
for site in google.com github.com amazon.com; do
    curl -Is --connect-timeout 5 http://$site > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        log "$site : UP"
    else
        log "$site : DOWN"
    fi
done
log ""

log "========================================"
log "Report saved : $(date)"
log "Output file  : $REPORT"
