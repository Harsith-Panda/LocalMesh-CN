#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd brew
[[ $# -eq 1 ]] || die "usage: $0 IP_ADDRESS"
TARGET_IP="$1"
[[ "$TARGET_IP" =~ ^[0-9.]+$ ]] || die "use a controlled IPv4 address"
CONF="${DNSMASQ_CONF:-$(brew --prefix)/etc/dnsmasq.conf}"
[[ -f "$CONF" ]] || die "dnsmasq config not found: $CONF"
BACKUP="$(backup_dir)"
sudo cp "$CONF" "$BACKUP/dnsmasq.conf"
sudo sed -E -i '' "s#^host-record=app\.$TEAM\.test,[0-9.]+#host-record=app.$TEAM.test,$TARGET_IP#" "$CONF"
sudo dnsmasq --test --conf-file="$CONF"
echo "app.$TEAM.test now points to $TARGET_IP"
echo "Backup: $BACKUP/dnsmasq.conf"
echo "Reload dnsmasq, run the TTL test, then restore the backup."
