# Phase 2 scripts

These scripts extend the Phase 1 LocalMesh setup. Run them from a repository copy
on the relevant machine after `source ~/cn-team.env`. They do not replace UTM or
the machine-specific runbook.

| Extension | Script | Run on |
|---|---|---|
| A: backup DNS setup | `setup-backup-dns.sh` | Manohar's Mac |
| A: backup DNS start/stop | `start-backup-dns.sh`, `stop-backup-dns.sh` | Manohar's Mac |
| A: backup DNS test | `test-dns-failover.sh` | Any client |
| B: TTL | `configure-ttl.sh 30` | Your Mac |
| B: record cutover | `set-dns-record.sh IP` | Your Mac |
| B: TTL observation | `test-ttl-cutover.sh` | Any client |
| D: backend failover | `test-backend-failover.sh` | Any client |
| E: standby nginx | `setup-standby-edge.sh` | Temporary edge Mac |
| E: migration test | `test-edge-migration.sh` | Any client |
| C: isolation | `apply-backend-isolation.sh` | Your Mac |
| C: rollback | `rollback-backend-isolation.sh BACKUP` | Your Mac |
| F: diagnosis | `diagnose.sh` | Any client |

## Safety rules

- `apply-backend-isolation.sh` is a dry run unless invoked with `--apply`.
- Backups are created under `.phase2-backups/`; keep private machine-specific
  backups out of the final submission.
- Test standby nginx before firewall isolation, or allow its source temporarily.
- Always restore DNS records, resolver order, TTL, firewall rules, and standby
  nginx after each demonstration.
- Save Phase 2 evidence under `evidence/phase2/`, separate from Phase 1.

## Recommended order

1. Freeze the Phase 1 baseline.
2. Set up and test backup DNS.
3. Configure/test TTL and controlled DNS change.
4. Test backend failover.
5. Configure/test standby edge migration.
6. Apply/test/rollback backend isolation.
7. Practice `diagnose.sh` and the faculty troubleshooting sequence.
