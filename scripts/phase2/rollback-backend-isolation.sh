#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
need_cmd pfctl
[[ $# -eq 1 ]] || die "usage: $0 /path/to/pf.conf.before"
[[ -f "$1" ]] || die "backup not found: $1"
sudo cp "$1" /etc/pf.conf
sudo pfctl -nf /etc/pf.conf
sudo pfctl -f /etc/pf.conf
echo 'Previous pf configuration restored.'
