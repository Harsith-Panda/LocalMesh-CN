# Phase 2 evidence structure

Save evidence from the live demonstrations in the matching extension folder.
Use dated filenames such as `A1-backup-dns-config-2026-11-23.png`.
Keep private keys, personal settings, and unredacted firewall backups outside the
repository.

## Required evidence map

| Folder | Extension | Evidence to collect |
|---|---|---|
| `A-dns-failover/` | A: Backup DNS | Backup config, client resolver list, normal lookup, primary stopped lookup, recovery |
| `B-dns-ttl-cutover/` | B: TTL and record change | TTL before change, old cached answer, new answer after expiry/flush, restored record |
| `C-backend-isolation/` | C: Firewall isolation | Rules, edge allowed, client denied, HTTPS still works, rollback |
| `D-backend-failover/` | D: Backend HA failover | Healthy A/B, Backend A stopped, B-only, A restarted, A/B resumed |
| `E-edge-migration/` | E: DNS edge migration | Standby config, old edge, DNS change, standby response, TTL effect, restoration |
| `F-troubleshooting/` | F: Faculty troubleshooting | Injected fault, diagnosis commands, affected layer, fix, final verification |
| `tcp/` | Phase 2 packet evidence | DNS failover/cutover and relevant TCP/TLS captures |
| `final-demo/` | Final presentation | Final topology, service inventory, final sequence, cleanup proof |

Each extension folder contains an `INDEX.md` checklist. Update it only with
evidence that was actually collected.
