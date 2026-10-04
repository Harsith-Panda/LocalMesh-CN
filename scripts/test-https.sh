#!/bin/bash
# Prefer /usr/bin/curl on macOS so the System keychain is used.
set -euo pipefail
source "$HOME/cn-team.env"
CURL=/usr/bin/curl
if [[ ! -x $CURL ]]; then CURL=curl; fi
$CURL -sv "https://app.$TEAM.test:8443/api/status" 2>&1 | grep -E "SSL connection|issuer|^< HTTP|x-backend"
