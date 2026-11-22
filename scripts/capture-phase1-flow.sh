#!/bin/bash
# Capture a clean DNS -> TCP -> TLS flow for Task G.
set -euo pipefail
source "$HOME/cn-team.env"
OUT="${1:-evidence/phase1/tcp/phase1-flow-$(date +%Y-%m-%d-%H%M%S).pcap}"
CAPTURE_IFACE="${CAPTURE_IFACE:-en0}"
mkdir -p "$(dirname "$OUT")"
echo "Capturing to $OUT (Ctrl-C after the request completes)."
echo "In another terminal run: /usr/bin/curl -sv https://app.$TEAM.test:8443/api/status"
sudo tcpdump -i "$CAPTURE_IFACE" -s 0 -w "$OUT" \
  "(udp port 53) or (tcp host $MANOHAR_MAC_IP and port 8443)"
