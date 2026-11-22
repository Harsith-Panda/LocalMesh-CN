#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
CURL="$(curl_cmd)"
URL="https://app.$TEAM.test:8443/api/status"
COUNT="${1:-8}"
for i in $(seq 1 "$COUNT"); do
  printf 'request %02d: ' "$i"
  "$CURL" -sS --connect-timeout 3 -D - -o /dev/null "$URL" \
    | grep -iE '^HTTP/|^x-backend:' | tr '\n' ' '
  echo
done
echo "Stop Backend A and rerun; successful responses should be X-Backend: B."
