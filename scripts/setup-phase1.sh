#!/usr/bin/env bash
# Single entry point for the four Phase 1 roles.
# Run exactly one role on each corresponding device.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: ./scripts/setup-phase1.sh ROLE

ROLE must be one of:
  dns        Your Mac: dnsmasq / Mac 1
  edge       Manohar's Mac: nginx + TLS / Mac 2
  backend-a  Ubuntu VM with host port 3001
  backend-b  LocalMesh-1 Ubuntu VM with host port 3002

This dispatcher runs the role's prerequisite installer and prints the remaining
role-specific actions. It does not change UTM port forwarding or network DNS
settings automatically because those are machine-specific and destructive.
EOF
}

[[ $# -eq 1 ]] || { usage; exit 2; }

case "$1" in
  dns)       target="$SCRIPT_DIR/setup-mac1-dns.sh"; label='Mac 1 DNS' ;;
  edge)      target="$SCRIPT_DIR/setup-mac2-nginx.sh"; label='Mac 2 edge' ;;
  backend-a) target="$SCRIPT_DIR/setup-ubuntu-vm-a.sh"; label='Backend A VM' ;;
  backend-b) target="$SCRIPT_DIR/setup-ubuntu-vm-b.sh"; label='Backend B VM' ;;
  -h|--help) usage; exit 0 ;;
  *) echo "Unknown role: $1" >&2; usage >&2; exit 2 ;;
esac

echo "=== LocalMesh Phase 1: $label ==="
echo "Running $target"
echo
exec bash "$target"
