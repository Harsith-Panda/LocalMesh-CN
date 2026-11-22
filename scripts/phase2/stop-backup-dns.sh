#!/usr/bin/env bash
set -euo pipefail
PIDFILE="${BACKUP_DNS_PIDFILE:-/var/run/localmesh-backup-dnsmasq.pid}"
[[ -f "$PIDFILE" ]] || { echo 'backup dnsmasq is not running'; exit 0; }
PID="$(sudo cat "$PIDFILE")"
sudo kill "$PID"
echo "backup dnsmasq stopped"
