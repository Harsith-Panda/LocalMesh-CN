#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd dig
HOST="${1:-app.$TEAM.test}"
WAIT="${2:-30}"
echo '--- before change ---'
dig +noall +answer @"$YOUR_MAC_IP" "$HOST" A
echo "Change the record, reload dnsmasq, then press Enter."
read -r
dig +noall +answer @"$YOUR_MAC_IP" "$HOST" A
echo "Waiting $WAIT seconds before checking through the client resolver."
sleep "$WAIT"
dig +noall +answer "$HOST" A
