#!/bin/bash
set -euo pipefail
source "$HOME/cn-team.env"
CURL=/usr/bin/curl
if [[ ! -x $CURL ]]; then CURL=curl; fi
for i in 1 2 3 4 5 6; do
  echo "Request $i:"
  $CURL -s -D - -o /dev/null "https://app.$TEAM.test:8443/api/status" | grep -i x-backend
done
