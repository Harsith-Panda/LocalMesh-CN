#!/usr/bin/env bash
set -euo pipefail

PHASE2_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$PHASE2_DIR/../.." && pwd)"
[[ -f "$HOME/cn-team.env" ]] && source "$HOME/cn-team.env"

die() { echo "ERROR: $*" >&2; exit 1; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }
need_env() { [[ -n "${!1:-}" ]] || die "set $1 in ~/cn-team.env"; }
load_team() {
  need_env TEAM; need_env YOUR_MAC_IP; need_env MANOHAR_MAC_IP
  BACKUP_DNS_IP="${BACKUP_DNS_IP:-$MANOHAR_MAC_IP}"
  export BACKUP_DNS_IP
}
curl_cmd() { if [[ -x /usr/bin/curl ]]; then echo /usr/bin/curl; else echo curl; fi; }
stamp() { date +%Y%m%d-%H%M%S; }
backup_dir() { local d="${1:-$REPO_DIR/.phase2-backups}/$(stamp)"; mkdir -p "$d"; echo "$d"; }
