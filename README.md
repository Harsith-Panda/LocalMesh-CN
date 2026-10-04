# LocalMesh - Private Network Service Platform

Computer Networks Course Project - Phase 1 & Phase 2

## Project Overview

This project implements a private network service platform where a client machine resolves a private domain name through a custom DNS server, establishes a secure HTTPS connection through a reverse proxy, and receives responses from backend application servers.

## Folder Structure

```
LocalMesh/
├── backend-a/           # Backend Server A application code
├── backend-b/           # Backend Server B application code
├── config/              # Configuration files
│   ├── dnsmasq/        # DNS server configuration
│   ├── nginx/          # Nginx reverse proxy configuration
│   └── tls/            # TLS certificates and setup
├── evidence/            # Screenshots, Wireshark captures, test outputs
├── scripts/             # Helper scripts for setup and testing
└── README.md           # This file
```

## Network Roles

- **Mac 1 (Physical)**: Private DNS Server + Test Client
- **Mac 2 (Physical)**: Edge/Reverse Proxy + Load Balancer
- **Mac 1 VM (Ubuntu)**: Backend Server A (port 3001)
- **Mac 2 VM (Ubuntu)**: Backend Server B (port 3002) + Test Client

## Network Configuration

- **Mode**: Bridge Network (UTM)
- **Domain**: `.test` namespace (e.g., app.teamX.test)
- **Private LAN**: All machines on same Wi-Fi/LAN

## Quick Start

### Phase 1 Setup

1. **Configure LAN**: Connect all machines to same private network
2. **Setup DNS**: Install and configure dnsmasq on Mac 1
3. **Build Backends**: Deploy backend applications on VMs
4. **Configure Edge**: Setup nginx reverse proxy on Mac 2
5. **Add TLS**: Generate certificates and configure HTTPS
6. **Test**: Verify end-to-end flow with Wireshark captures

### Phase 2 Extensions

1. **Backup DNS**: Configure secondary DNS resolver
2. **DNS TTL**: Demonstrate caching and TTL behavior
3. **Service Isolation**: Restrict backend port access
4. **HA Failover**: Configure nginx health checks
5. **Edge Migration**: Implement DNS-based cutover

## Tools Required

- Homebrew
- dnsmasq
- nginx
- OpenSSL
- Python or Node.js
- Wireshark
- curl
- dig/nslookup

## Deliverables

### Phase 1
- Architecture document
- Configuration bundle
- Backend source code
- Evidence folder
- Live demonstration

### Phase 2
- Updated architecture document
- Phase 2 configuration additions
- Phase 2 evidence
- Final report
- Final presentation

## Testing

Run test scripts from the `scripts/` directory:

```bash
./scripts/test-dns.sh
./scripts/test-backend.sh
./scripts/test-https.sh
./scripts/test-load-balancing.sh
```

## Documentation

Detailed plans and documentation are available in the `docs/` folder (not committed to Git).

## Team

Team members:
- [Add team member 1]
- [Add team member 2]
- [Add team member 3]
- [Add team member 4]
