#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd dig
need_cmd openssl
CURL="$(curl_cmd)"
HOST="${1:-app.$TEAM.test}"
PORT="${2:-8443}"
echo '=== DNS ==='
dig +short "$HOST" A
dig +short @"$YOUR_MAC_IP" "$HOST" A
echo '=== TCP ==='
(nc -vz -G 3 "$HOST" "$PORT" || true)
echo '=== TLS ==='
echo | openssl s_client -connect "$HOST:$PORT" -servername "$HOST" 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates 2>/dev/null || true
echo '=== APPLICATION ==='
"$CURL" -sS --connect-timeout 3 -D - -o /dev/null "https://$HOST:$PORT/api/status" || true
echo 'Diagnosis order: DNS -> TCP -> TLS -> application.'
