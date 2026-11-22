#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd dig
PRIMARY="${1:-$YOUR_MAC_IP}"
BACKUP="${2:-$BACKUP_DNS_IP}"
for server in "$PRIMARY" "$BACKUP"; do
  echo "--- @$server ---"
  dig +time=2 +tries=1 @"$server" "app.$TEAM.test" A \
    | grep -E 'SERVER:|app\.' || true
done
echo "Stop the primary DNS service and rerun this command to prove failover."
