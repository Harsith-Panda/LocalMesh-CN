# Phase 1 evidence index (from ~/Downloads/evidence-phase1)

Values from `~/cn-team.env`: `TEAM=localmesh`, `YOUR_MAC_IP=10.7.12.104`, `MANOHAR_MAC_IP=10.7.2.38`.

| File | Shows |
| --- | --- |
| `dns/dns-config-and-resolution-2026-10-04.jpg` | dnsmasq on `10.7.12.104:53` and `127.0.0.1:53`; zone `localmesh.test`; A records → `10.7.2.38`; `dig` SERVER `#53` |
| `http/lan-ping-and-direct-backends-2026-10-04.jpg` | Ping both Macs; `X-Backend: A` on :3001; `X-Backend: B` on :3002; Cache-Control / ETag |
| `tls/https-issuer-and-x-backend-2026-10-04.jpg` | TLSv1.3; issuer `localmesh Local Root CA`; HTTP/2; mixed A/B then some HTTP/2 501 |
| `tls/browser-app.localmesh.test-8443-2026-10-04.jpg` | Browser on `app.localmesh.test:8443` JSON `backend: A` (pretty-print) |
| `http/backend-a-local-2026-10-04.jpg` | Guest listen `0.0.0.0:3001`; `/api/status` A. `curl -I /` is 501 (HEAD not implemented) |
| `http/backend-b-local-2026-10-04.jpg` | Guest listen `0.0.0.0:3002`; `/api/status` B; `dig` → `10.7.2.38` |
| `tcp/flow-dns-and-8443-2026-10-04.pcap` | tcpdump UDP/53 + TCP/8443 |
| `failures/f1-wrong-client-dns-nxdomain-2026-10-04.jpg` | Client DNS `8.8.8.8`; `app.localmesh.test` NXDOMAIN |

## Still missing for Review 1

- Wireshark screenshots of DNS / TCP handshake / TLS packets (open the `.pcap`)
- F2 wrong A record, F3 one backend stopped, F4 both stopped (502), F5 wrong port
- Dedicated 304 / If-None-Match shot (ETags differ: `backend-a-v1` vs `backend-b-v1`)
- `openssl verify` / nginx config screenshots
