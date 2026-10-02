# Evidence Folder

This directory contains all evidence collected during testing and demonstrations.

## Required Evidence

### Phase 1 Evidence
- DNS resolution screenshots (dig/nslookup output)
- curl/browser output with headers
- Wireshark captures:
  - DNS query and response
  - TCP three-way handshake
  - TLS handshake
  - HTTP request/response
- HTTP caching demonstration
- Failure scenario demonstrations:
  - Wrong DNS server
  - Wrong DNS record
  - One backend stopped
  - Both backends stopped
  - Wrong destination port

### Phase 2 Evidence
- Backup DNS failover demonstration
- DNS TTL and caching behavior
- Service isolation (firewall rules)
- High-availability failover
- Edge migration (DNS-based cutover)
- Faculty-injected fault diagnosis

## File Naming Convention

Use descriptive filenames:
- `dns-resolution-<date>.png`
- `tcp-handshake-<date>.pcap`
- `tls-handshake-<date>.pcap`
- `load-balancing-<date>.txt`
- `cache-demo-<date>.png`
- `failover-<date>.png`

## Organization

Organize by phase and type:
```
evidence/
├── phase1/
│   ├── dns/
│   ├── tcp/
│   ├── tls/
│   ├── http/
│   └── failures/
└── phase2/
    ├── dns-failover/
    ├── ttl-caching/
    ├── isolation/
    ├── ha-failover/
    └── edge-migration/
```
