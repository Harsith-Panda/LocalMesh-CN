#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd dig
CURL="$(curl_cmd)"
HOST="${1:-app.$TEAM.test}"
echo '--- current DNS answer ---'
dig +noall +answer "$HOST" A
echo '--- current HTTPS edge ---'
"$CURL" -sS --connect-timeout 3 -D - -o /dev/null "https://$HOST:8443/api/status" \
  | grep -iE '^HTTP/|^server:|^x-backend:' || true
echo 'Change the DNS record to the standby edge, wait/flush according to the TTL plan, then rerun.'
