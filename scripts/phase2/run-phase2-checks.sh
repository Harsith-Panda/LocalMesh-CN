#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
echo 'LocalMesh Phase 2 quick-check commands:'
echo "1. scripts/phase2/test-dns-failover.sh $YOUR_MAC_IP $BACKUP_DNS_IP"
echo '2. scripts/phase2/configure-ttl.sh 30'
echo '3. scripts/phase2/test-backend-failover.sh'
echo '4. scripts/phase2/test-edge-migration.sh'
echo '5. scripts/phase2/diagnose.sh'
echo '6. scripts/capture-phase1-flow.sh and scripts/verify-phase1-flow.sh'
echo 'Destructive changes require explicit apply/restore commands.'
