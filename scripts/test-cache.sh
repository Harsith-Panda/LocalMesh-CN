#!/bin/bash
# Demonstrate Phase 1 caching at the edge. Run from a trusted client Mac.
set -euo pipefail
source "$HOME/cn-team.env"
CURL=/usr/bin/curl
[[ -x "$CURL" ]] || CURL=curl
URL="https://app.$TEAM.test:8443/api/status"

echo '--- initial response headers ---'
headers="$($CURL -sS -D - -o /dev/null "$URL")"
printf '%s\n' "$headers" | grep -iE 'HTTP/|cache-control:|etag:|x-backend:'
etag="$(printf '%s\n' "$headers" | awk 'BEGIN{IGNORECASE=1} /^etag:/ {sub(/^[^:]*:[[:space:]]*/, ""); print; exit}')"
[[ -n "$etag" ]] || { echo 'No ETag returned' >&2; exit 1; }

echo '--- conditional requests (one should return 304) ---'
for attempt in 1 2 3 4; do
  result="$($CURL -sS -D - -o /dev/null -H "If-None-Match: $etag" "$URL")"
  printf 'attempt %s: ' "$attempt"
  printf '%s\n' "$result" | grep -iE '^HTTP/' | head -n 1
  if printf '%s\n' "$result" | grep -qE '^HTTP/[^ ]+ 304 '; then
    printf '%s\n' "$result" | grep -iE 'cache-control:|etag:|x-backend:'
    exit 0
  fi
done
echo 'No 304 received; repeat after confirming both backends use the updated code.' >&2
exit 1
