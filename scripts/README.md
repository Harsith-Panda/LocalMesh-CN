# Helper Scripts

This directory contains helper scripts for setup, testing, and automation.

## Available Scripts

### Setup Scripts
- `setup-phase1.sh ROLE` - single entry point; run once per device with `dns`, `edge`, `backend-a`, or `backend-b`
- `setup-mac1-dns.sh` - Install and configure dnsmasq on Your Mac (DNS Server)
- `setup-mac2-nginx.sh` - Install and configure nginx on Manohar's Mac (Edge/Proxy)
- `setup-ubuntu-vm-a.sh` - Install and configure Backend A on Your VM 1
- `setup-ubuntu-vm-b.sh` - Install and configure Backend B on Your VM 2

### Test Scripts (after the full setup)
- `test-dns.sh` — resolve `app.$TEAM.test` (should be Manohar's Mac)
- `test-backend.sh` — curl `YOUR_MAC_IP:3001` and `:3002`
- `test-https.sh` — HTTPS via the domain on :8443
- `test-load-balancing.sh` — six requests, expect A/B alternating
- `test-cache.sh` — shows Cache-Control/ETag and validates a conditional request
- `capture-phase1-flow.sh` — captures the clean DNS/TCP/TLS flow for Task G
- `verify-phase1-flow.sh` — rejects captures without SYN-ACK or TLS handshake packets

Phase 2 scripts are in `scripts/phase2/`; see `scripts/phase2/README.md` for the
extension-to-machine mapping and rollback order.

Read `docs/START-HERE.md` first. These scripts do not replace the machine guides.

## Usage

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

Run scripts on each machine:

**Your Mac (DNS Server):**
```bash
./scripts/setup-phase1.sh dns
```

**Manohar's Mac (nginx Edge):**
```bash
./scripts/setup-phase1.sh edge
```

**Your VM 1 (Backend A):**
```bash
./scripts/setup-phase1.sh backend-a
```

**Your VM 2 (Backend B):**
```bash
./scripts/setup-phase1.sh backend-b
```

## What These Scripts Do

Each setup script:
- Installs required dependencies (dnsmasq, nginx, python3)
- Loads and validates the existing shared settings file (`~/cn-team.env`)
- Gathers network information (IP, gateway, hostname)
- Configures firewall (on Ubuntu VMs)
- Creates necessary directories
- Provides next steps for manual configuration

## Important Notes

1. **Prepare `~/cn-team.env` first**: The setup scripts never create, overwrite, or change this file. Put the current physical Mac IPs in it before running a role script.

2. **Source the settings file**: Run `source ~/cn-team.env` to load the environment variables.

3. **Follow the detailed guides**: The scripts automate the initial setup, but you must follow the detailed step-by-step guides in the `docs/` folder for complete configuration.

4. **Team coordination**: Both Macs must coordinate to fill in the team table with their IPs before editing their settings files.

5. **UTM (Emulated VLAN)**:
   - VM that forwards 3001 → Backend A (`setup-ubuntu-vm-a.sh`)
   - **LocalMesh - 1** forwards 3002 → Backend B (`setup-ubuntu-vm-b.sh`)

## Phase 1 evidence checks

Run `test-cache.sh` from a trusted client after both backends are live. For packet
evidence, set `CAPTURE_IFACE` to the active Wi-Fi interface if it is not `en0`, run
`capture-phase1-flow.sh`, make one HTTPS request in another terminal, stop the
capture, and run `verify-phase1-flow.sh` on the resulting pcap. The five required
failure demonstrations are documented in `test-failure-scenarios.md` and must be
run against the live two-Mac/UTM setup.

## Manual Steps Still Required

After running the setup scripts, you still need to complete:

**Your Mac (DNS Server):**
- Edit dnsmasq configuration
- Start dnsmasq service
- Configure DNS resolution

**Manohar's Mac (nginx Edge):**
- Generate TLS certificates
- Configure nginx upstream servers (point to YOUR_MAC_IP:3001 and YOUR_MAC_IP:3002)
- Start nginx service

**Your VMs:**
- Copy `app.py` to the backend directory
- Start the backend service
- Configure DNS resolution
- Trust the team CA certificate

See the detailed guides in `docs/` for complete instructions.
