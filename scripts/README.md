# Helper Scripts

This directory contains helper scripts for setup, testing, and automation.

## Available Scripts

### Setup Scripts
- `setup-mac1-dns.sh` - Install and configure dnsmasq on Mac 1 (DNS Server)
- `setup-mac2-nginx.sh` - Install and configure nginx on Mac 2 (Edge/Proxy)
- `setup-ubuntu-vm-a.sh` - Install and configure Backend A on Ubuntu VM A
- `setup-ubuntu-vm-b.sh` - Install and configure Backend B on Ubuntu VM B

## Usage

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

Run scripts on each machine:

**Mac 1 (DNS Server):**
```bash
./scripts/setup-mac1-dns.sh
```

**Mac 2 (nginx Edge):**
```bash
./scripts/setup-mac2-nginx.sh
```

**Ubuntu VM A (Backend A):**
```bash
./scripts/setup-ubuntu-vm-a.sh
```

**Ubuntu VM B (Backend B):**
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

4. **Team coordination**: All machines must coordinate to fill in the team table with their IPs before editing their settings files.

## Manual Steps Still Required

After running the setup scripts, you still need to complete:

**Mac 1:**
- Edit dnsmasq configuration
- Start dnsmasq service
- Configure DNS resolution

**Mac 2:**
- Generate TLS certificates
- Configure nginx upstream servers
- Start nginx service

**Ubuntu VMs:**
- Copy `app.py` to the backend directory
- Start the backend service
- Configure DNS resolution
- Trust the team CA certificate

See the detailed guides in `docs/` for complete instructions.
