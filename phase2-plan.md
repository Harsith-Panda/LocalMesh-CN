# LocalMesh Phase 2 Implementation Plan

This plan extends the working Phase 1 system. Do not rebuild the topology. Before
starting, preserve the completed Phase 1 baseline: a successful DNS/TCP/TLS pcap,
the cache proof, and the Phase 1 failure evidence.

## Phase 2 target state

```text
Client Macs
   |  primary DNS: 10.7.12.104
   |  backup DNS:  10.7.2.38
   v
DNS failover + 30-second TTL/cutover
   |
   +--> primary nginx edge: 10.7.2.38:8443
   +--> standby nginx edge: 10.7.12.104:8443 (temporary migration target)
   +--> protected backends: 10.7.12.104:3001 / :3002
```

The standby edge is temporary and should be enabled only for the migration test.
The current single point of failure remains the edge service unless a second edge
is kept active and the DNS cutover is completed.

## Stage 0 — Freeze the Phase 1 baseline

| Check | Acceptance evidence |
|---|---|
| DNS, HTTPS, and both backends work | Existing Phase 1 test output |
| Packet flow is complete | Phase 1 pcap passes `scripts/verify-phase1-flow.sh` |
| Cache behavior is proven | `scripts/test-cache.sh` shows `304` |
| Phase 1 failures are recorded | F1–F5 screenshots/terminal captures |
| Rollback material exists | Copies of dnsmasq, nginx, pf, and resolver settings |

Create a timestamped backup directory outside the live configuration paths. Do not
apply Phase 2 changes until this gate is satisfied.

## Stage 1 — Extension A: backup DNS

Owner: Manohar's Mac (`10.7.2.38`).

1. Install/configure a second dnsmasq instance with the same `app` and `api`
   records as the primary DNS server.
2. Confirm it listens on the LAN address and UDP/TCP 53.
3. Configure client Macs with both DNS addresses, primary first.
4. Verify normal resolution and record the responding server.
5. Stop primary dnsmasq on Your Mac.
6. Resolve repeatedly from a client and show the service still resolves through
   the backup.
7. Restart primary dnsmasq and restore primary-first resolver order.

Evidence: backup config, client resolver settings, normal lookup, lookup while
primary is stopped, and recovery lookup.

## Stage 2 — Extension B: TTL and controlled DNS change

Owner: Your Mac (primary DNS).

1. Add an explicit short TTL, preferably 30 seconds, to the project records.
2. Resolve `app.localmesh.test` from a client and save the answer plus TTL.
3. Change the record to the standby edge address, without changing the client.
4. Show that a cached client continues to use the old answer until the TTL expires.
5. Flush the client DNS cache and show the new answer immediately.
6. Restore the original record and verify the original answer after propagation.

Evidence: before/after `dig`, TTL values, cache-before-expiry, post-expiry, manual
flush, and restored-record results. Do not use a public IP that could receive
unintended traffic.

## Stage 3 — Extension D: backend failover

Owner: Manohar's Mac / nginx.

1. Verify the upstream has passive failover (`max_fails`, `fail_timeout`, and
   `proxy_next_upstream`).
2. Capture a healthy sequence showing both `X-Backend: A` and `X-Backend: B`.
3. Stop Backend A only.
4. Make repeated HTTPS requests until nginx marks A unavailable; all successful
   responses must come from B.
5. Restart Backend A and verify distribution resumes after recovery.
6. Record that nginx/edge remains a single point of failure.

Evidence: A/B baseline, Backend A stopped, B-only responses, restart, and resumed
load balancing.

## Stage 4 — Extension E: controlled edge migration

Owner: Your Mac as temporary standby edge.

Do this before restrictive backend firewall rules, or add a temporary firewall
exception for the standby edge.

1. Copy the nginx server, upstream, TLS certificate, and key configuration to the
   standby edge location. Keep private keys out of the repository.
2. Start standby nginx on port 8443 and test it with the correct Host header and
   trusted CA.
3. Change the DNS A record for `app.localmesh.test` to the standby edge address.
4. Show old cached clients reaching the primary while fresh lookups reach standby.
5. After TTL expiry or a cache flush, verify the standby serves both backends.
6. Restore DNS to the primary edge, flush/expire caches, and stop the standby.

Evidence: standby test, DNS before/after, TTL behavior, old-edge response,
new-edge response, and restoration.

## Stage 5 — Extension C: backend service isolation

Owner: Your Mac host, because it publishes ports 3001 and 3002.

1. Export the current pf/firewall state and save a rollback copy.
2. Add rules permitting only `MANOHAR_MAC_IP` to TCP 3001 and 3002.
3. Confirm nginx on Manohar's Mac can still reach both backends.
4. From a non-edge client, confirm direct access to both ports fails.
5. Confirm the edge HTTPS service still works.
6. Roll back the rules after the demonstration and verify direct access returns.

Never apply a rule without a tested rollback command. During Edge Migration, either
run this stage before migration or temporarily allow the standby edge source.

Evidence: saved rules, edge success, client denial, HTTPS success, rollback, and
post-rollback verification.

## Stage 6 — Extension F: troubleshooting preparation

Use this fixed diagnosis order during the faculty challenge:

1. **DNS:** `dig`, resolver list, answer address, and TTL.
2. **TCP:** `nc -vz host port` or `curl` connection output.
3. **TLS:** certificate name, issuer, trust chain, and `openssl s_client` output.
4. **Application:** HTTP status, `X-Backend`, upstream errors, and logs.

Practice faults such as a wrong DNS server, wrong A record, blocked backend port,
expired/untrusted CA, and stopped backend. Record the fault, affected layer,
observation, correction, and final verification.

## Recommended execution order

1. Freeze Phase 1 baseline.
2. Backup DNS.
3. TTL and controlled DNS change.
4. Backend failover.
5. Edge migration.
6. Backend isolation.
7. Troubleshooting practice and final integrated run.

This order keeps the standby edge usable before firewall restrictions are applied.

## Phase 2 evidence layout

```text
evidence/phase2/
├── dns-failover/
├── dns-ttl-cutover/
├── backend-isolation/
├── backend-failover/
├── edge-migration/
├── troubleshooting/
└── tcp/
```

Keep Phase 1 and Phase 2 captures separate. Name every file with the extension,
scenario, and date.

## Completion gate

Phase 2 is ready for final submission when Extensions A–F each have a configuration
record, before/after test result, rollback result where applicable, and a short
explanation of the networking concept demonstrated. The final report must explain
what changed from Phase 1, observed results, remaining single points of failure,
and the troubleshooting diagnosis.
