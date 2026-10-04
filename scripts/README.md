# Helper Scripts

This directory contains helper scripts for setup, testing, and automation.

## Available Scripts

### Setup Scripts
- `setup-mac1-dns.sh` - Install and configure dnsmasq on Your Mac (DNS Server)
- `setup-mac2-nginx.sh` - Install and configure nginx on Manohar's Mac (Edge/Proxy)
- `setup-ubuntu-vm-a.sh` - Install and configure Backend A on Your VM 1
- `setup-ubuntu-vm-b.sh` - Install and configure Backend B on Your VM 2

### Test Scripts (after the full setup)
- `test-dns.sh` — resolve `app.$TEAM.test` (should be Manohar's Mac)
- `test-backend.sh` — curl `YOUR_MAC_IP:3001` and `:3002`
- `test-https.sh` — HTTPS via the domain on :8443
- `test-load-balancing.sh` — six requests, expect A/B alternating

Read `docs/START-HERE.md` first. These scripts do not replace the machine guides.

## Usage

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

Run scripts on each machine:

**Your Mac (DNS Server):**
```bash
./scripts/setup-mac1-dns.sh
```

**Manohar's Mac (nginx Edge):**
```bash
./scripts/setup-mac2-nginx.sh
```

**Your VM 1 (Backend A):**
```bash
./scripts/setup-ubuntu-vm-a.sh
```

**Your VM 2 (Backend B):**
```bash
./scripts/setup-ubuntu-vm-b.sh
```

## What These Scripts Do

Each setup script:
- Installs required dependencies (dnsmasq, nginx, python3)
- Creates the shared settings file template (`~/cn-team.env`)
- Gathers network information (IP, gateway, hostname)
- Configures firewall (on Ubuntu VMs)
- Creates necessary directories
- Provides next steps for manual configuration

## Important Notes

1. **Edit `~/cn-team.env`**: After running the setup script, you must edit the settings file and replace all `CHANGE_ME` values with real IPs from your team table.

2. **Source the settings file**: Run `source ~/cn-team.env` to load the environment variables.

3. **Follow the detailed guides**: The scripts automate the initial setup, but you must follow the detailed step-by-step guides in the `docs/` folder for complete configuration.

4. **Team coordination**: Both Macs must coordinate to fill in the team table with their IPs before editing their settings files.

5. **UTM (Emulated VLAN)**:
   - VM that forwards 3001 → Backend A (`setup-ubuntu-vm-a.sh`)
   - **LocalMesh - 1** forwards 3002 → Backend B (`setup-ubuntu-vm-b.sh`)

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
