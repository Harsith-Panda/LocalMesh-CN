# Configuration Files

This directory contains all configuration files for the network services.

## Structure

```
config/
├── dnsmasq/      # DNS server configuration
│   └── dnsmasq.conf
├── nginx/        # Nginx reverse proxy configuration
│   └── nginx.conf
└── tls/          # TLS certificates and setup
    ├── cert.pem
    ├── key.pem
    └── setup-notes.md
```

## dnsmasq Configuration

Configure DNS records for:
- `app.teamX.test` → Edge machine IP
- `api.teamX.test` → Edge machine IP

## nginx Configuration

Configure:
- Reverse proxy to backends
- Round-robin load balancing
- TLS/HTTPS termination
- Upstream servers (Backend A:3001, Backend B:3002)

## TLS Setup

Generate self-signed certificates for app.teamX.test using OpenSSL.
