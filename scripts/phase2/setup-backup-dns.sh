#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd brew

if brew list dnsmasq >/dev/null 2>&1; then
  DNSMASQ="$(brew --prefix dnsmasq)/sbin/dnsmasq"
else
  brew install dnsmasq
  DNSMASQ="$(brew --prefix dnsmasq)/sbin/dnsmasq"
fi
CONF="$(brew --prefix)/etc/dnsmasq-localmesh-backup.conf"
PIDFILE="/var/run/localmesh-backup-dnsmasq.pid"

sudo mkdir -p "$(dirname "$CONF")"
sudo tee "$CONF" >/dev/null <<EOF
port=53
listen-address=$BACKUP_DNS_IP
bind-interfaces
no-resolv
server=${COLLEGE_DNS:-8.8.8.8}
server=1.1.1.1
local=/$TEAM.test/
host-record=app.$TEAM.test,$MANOHAR_MAC_IP
host-record=api.$TEAM.test,$MANOHAR_MAC_IP
domain-needed
bogus-priv
log-queries
EOF
sudo "$DNSMASQ" --test --conf-file="$CONF"
echo "Backup DNS config ready: $CONF"
echo "Start: sudo $DNSMASQ --conf-file=$CONF --pid-file=$PIDFILE"
echo "Stop:  sudo kill \$(sudo cat $PIDFILE)"
