#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd pfctl
ANCHOR='com.localmesh.phase2'
RULES="/etc/pf.anchors/$ANCHOR"
BACKUP="$(backup_dir)"
if [[ "${1:-}" != "--apply" ]]; then
  echo "DRY RUN: allow only $MANOHAR_MAC_IP to TCP 3001/3002 and block other inbound clients."
  echo "Run '$0 --apply' only after confirming rollback."
  exit 0
fi
sudo pfctl -sr >"$BACKUP/pf.rules.before"
sudo cp /etc/pf.conf "$BACKUP/pf.conf.before"
sudo tee "$RULES" >/dev/null <<EOF
pass in quick proto tcp from $MANOHAR_MAC_IP to any port { 3001, 3002 } keep state
block in quick proto tcp to any port { 3001, 3002 }
EOF
if ! sudo grep -q 'com.localmesh.phase2' /etc/pf.conf; then
  echo 'anchor "com.localmesh.phase2"' | sudo tee -a /etc/pf.conf >/dev/null
fi
sudo pfctl -nf /etc/pf.conf
sudo pfctl -f /etc/pf.conf
echo "Isolation applied. Restore with: sudo pfctl -f $BACKUP/pf.conf.before"
