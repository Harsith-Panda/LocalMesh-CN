# Helper Scripts

This directory contains helper scripts for setup, testing, and automation.

## Available Scripts

### Setup Scripts
- `setup-dns.sh` - Install and configure dnsmasq
- `setup-nginx.sh` - Install and configure nginx
- `setup-tls.sh` - Generate TLS certificates
- `setup-backend-a.sh` - Deploy Backend Server A
- `setup-backend-b.sh` - Deploy Backend Server B

### Test Scripts
- `test-dns.sh` - Test DNS resolution
- `test-backend.sh` - Test backend connectivity
- `test-https.sh` - Test HTTPS connection
- `test-load-balancing.sh` - Test load balancing
- `test-caching.sh` - Test HTTP caching

### Diagnostic Scripts
- `check-network.sh` - Verify network connectivity
- `check-ports.sh` - Check if ports are accessible
- `capture-packets.sh` - Start packet capture
- `flush-dns.sh` - Flush DNS cache

## Usage

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

Run scripts:
```bash
./scripts/test-dns.sh
./scripts/test-load-balancing.sh
```

## Script Templates

Scripts should include:
- Error handling
- Output logging
- Clear success/failure messages
- Help documentation
