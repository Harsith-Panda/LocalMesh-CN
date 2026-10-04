# LocalMesh - Private Network Service Platform

Computer Networks Course Project - Phase 1 & Phase 2

## Chosen setup: Option A

Both Ubuntu backend VMs run on **Your Mac** (UTM **Emulated VLAN** + port forwarding). **Manohar's Mac** is only the nginx edge. Start at `docs/START-HERE.md` (gitignored with the rest of `docs/`).

- UTM VM that forwards **3001** → Backend A
- UTM **LocalMesh - 1** forwards **3002** → Backend B

## Project Overview

A client resolves a private `.test` name through the team DNS server, opens HTTPS on the reverse proxy, and gets a response from one of two backend servers.

## Folder Structure

```
LocalMesh/
├── backend-a/           # Backend Server A (port 3001)
├── backend-b/           # Backend Server B (port 3002)
├── config/              # Reference dnsmasq / nginx / TLS notes
├── evidence/            # Screenshots, captures, test output
├── report/              # Phase 1 LaTeX report + architecture (commit this)
├── scripts/             # Optional helpers
├── docs/                # Private setup runbooks (gitignored)
└── README.md
```

## Network Roles (Option A)

- **Your Mac (physical)**: Private DNS (dnsmasq :53) + test client + UTM host
- **Manohar's Mac (physical)**: Edge / reverse proxy / TLS / load balancer (:8080 → :8443)
- **UTM VM (forward 3001)**: Backend A, published as `YOUR_MAC_IP:3001`
- **UTM LocalMesh - 1 (forward 3002)**: Backend B, published as `YOUR_MAC_IP:3002`

## Network Configuration

- **Mode**: UTM Emulated VLAN + TCP port forwarding (not Shared Network, not Bridged)
- **Domain**: `app.localmesh.test` / `api.localmesh.test` (`TEAM=localmesh` in `~/cn-team.env`)
- **LAN**: Both physical Macs on the same Wi-Fi; guests stay on the UTM NAT subnet

## What to follow, in order

1. `docs/START-HERE.md` — topology and reading order
2. `docs/CN_Project_Doc.pdf` — official requirements (skim)
3. `docs/architecture-phase1.md` — diagram for Review 1
4. `docs/0-common-setup.md` — team table, sync points, UTM forwards
5. One machine file, top to bottom:
   - Your Mac → `docs/1-mac1-dns-server.md`
   - Manohar's Mac → `docs/2-mac2-nginx-edge.md`
   - 3001 VM → `docs/3-ubuntu-vm-a-backend.md`
   - LocalMesh - 1 (3002) → `docs/4-ubuntu-vm-b-backend.md`
6. Together → `docs/5-final-verification.md`
7. Save proof using `evidence/README.md`

`scripts/setup-*.sh` are optional. They do not replace the machine files.

## Tools Required

- Homebrew, dnsmasq, nginx, OpenSSL
- Python 3, Wireshark, curl, dig/nslookup
- UTM (two Ubuntu VMs on Your Mac)

## Deliverables

### Phase 1
- Main report: `report/phase1-report.pdf` (LaTeX source in the same folder)
- Architecture handout: `report/architecture-phase1.pdf` (also copied to repo root)
- Configuration bundle (`config/`)
- Backend source (`backend-a/`, `backend-b/`)
- Evidence (`evidence/phase1/`)
- Live demonstration

Setup walkthroughs stay in `docs/` and are **not** committed.

### Phase 2
- Updated architecture, configs, evidence
- Final report and presentation

## Testing

After `source ~/cn-team.env` on a Mac:

```bash
./scripts/test-dns.sh
./scripts/test-backend.sh
./scripts/test-https.sh
./scripts/test-load-balancing.sh
```

## Team

- S. Harsith Priyan
- Guru Manohar Gupta
