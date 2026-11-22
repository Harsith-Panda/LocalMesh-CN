#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
need_cmd brew
DNSMASQ="$(brew --prefix dnsmasq)/sbin/dnsmasq"
CONF="${BACKUP_DNS_CONF:-$(brew --prefix)/etc/dnsmasq-localmesh-backup.conf}"
PIDFILE="${BACKUP_DNS_PIDFILE:-/var/run/localmesh-backup-dnsmasq.pid}"
[[ -x "$DNSMASQ" && -f "$CONF" ]] || die "run setup-backup-dns.sh first"
if [[ -f "$PIDFILE" ]] && sudo kill -0 "$(sudo cat "$PIDFILE")" 2>/dev/null; then
  echo "backup dnsmasq is already running"
  exit 0
fi
sudo "$DNSMASQ" --conf-file="$CONF" --pid-file="$PIDFILE"
echo "backup dnsmasq started using $CONF"
