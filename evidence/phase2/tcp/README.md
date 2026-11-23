# Phase 2 packet captures

Keep Phase 2 captures separate from `evidence/phase1/`.

- `A-dns-failover-YYYY-MM-DD.pcap` — primary/backup DNS behavior.
- `B-dns-ttl-cutover-YYYY-MM-DD.pcap` — TTL and record change.
- `D-backend-failover-YYYY-MM-DD.pcap` — edge/backend failover traffic.
- `E-edge-migration-YYYY-MM-DD.pcap` — DNS edge migration traffic.

For each pcap, record the capture interface, client machine, filter, time, and
scenario in a nearby text file. Do not use a Phase 2 pcap as a replacement for
the required Phase 1 baseline pcap.
