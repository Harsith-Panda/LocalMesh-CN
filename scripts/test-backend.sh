#!/bin/bash
# Hit both backends through Your Mac's published ports (Option A).
set -euo pipefail
source "$HOME/cn-team.env"
curl -s -D - -o /dev/null "http://$YOUR_MAC_IP:3001/api/status" | grep -iE "^HTTP|x-backend"
curl -s -D - -o /dev/null "http://$YOUR_MAC_IP:3002/api/status" | grep -iE "^HTTP|x-backend"
