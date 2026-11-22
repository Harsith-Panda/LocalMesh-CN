#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd brew
TTL="${1:-30}"
[[ "$TTL" =~ ^[0-9]+$ ]] || die "TTL must be an integer"
CONF="${DNSMASQ_CONF:-$(brew --prefix)/etc/dnsmasq.conf}"
[[ -f "$CONF" ]] || die "dnsmasq config not found: $CONF"
BACKUP="$(backup_dir)"
sudo cp "$CONF" "$BACKUP/dnsmasq.conf"
if sudo grep -q '^local-ttl=' "$CONF"; then
  sudo sed -E -i '' "s/^local-ttl=.*/local-ttl=$TTL/" "$CONF"
else
  echo "local-ttl=$TTL" | sudo tee -a "$CONF" >/dev/null
fi
sudo dnsmasq --test --conf-file="$CONF"
echo "Configured local TTL=$TTL in $CONF"
echo "Backup: $BACKUP/dnsmasq.conf"
echo "Reload dnsmasq before testing, then restore the backup afterward."
