#!/bin/bash
# Setup script for Mac 1 (DNS Server)
# This script automates the setup of dnsmasq on Mac 1
# Usage: ./setup-mac1-dns.sh

set -e  # Exit on error

echo "=== Mac 1 DNS Server Setup ==="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script must be run on macOS"
    exit 1
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not found. Install from https://brew.sh"
    exit 1
fi

# Step 1: Enable interactive comments
echo "Step 1: Enabling interactive comments..."
setopt interactivecomments 2>/dev/null || true
echo 'setopt interactivecomments' >> ~/.zshrc
echo "✓ Interactive comments enabled"
echo ""

# Step 2: Install dnsmasq
echo "Step 2: Installing dnsmasq..."
brew install dnsmasq
DNSMASQ_CONF="$(brew --prefix)/etc/dnsmasq.conf"
cp "$DNSMASQ_CONF" "$DNSMASQ_CONF.backup"
echo "✓ dnsmasq installed"
echo ""

# Step 3: Create settings file template
echo "Step 3: Creating settings file template..."
cat > ~/cn-team.env <<'EOF'
export TEAM=teamX                # team name: lowercase letters/digits only, no spaces or _
export MAC1_IP=CHANGE_ME           # Mac 1: DNS
export MAC2_IP=CHANGE_ME           # Mac 2: nginx edge
export UBUNTU_VM_A_IP=CHANGE_ME   # Ubuntu VM A: Backend A
export UBUNTU_VM_B_IP=CHANGE_ME   # Ubuntu VM B: Backend B
export COLLEGE_DNS=8.8.8.8         # Mac 1's "DNS server" line from Step 3
EOF
echo 'source ~/cn-team.env' >> ~/.zshrc
echo "✓ Settings file template created at ~/cn-team.env"
echo "   Please edit this file with real values before continuing"
echo ""

# Step 4: Network info
echo "Step 4: Gathering network information..."
WIFI_IF=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
echo "Wi-Fi Interface: $WIFI_IF"
echo "Your IP: $(ipconfig getifaddr $WIFI_IF)"
echo "Subnet mask: $(networksetup -getinfo Wi-Fi | grep 'Subnet mask' | awk '{print $3}')"
echo "Router: $(networksetup -getinfo Wi-Fi | grep 'Router' | awk '{print $2}')"
echo "MAC address: $(ifconfig $WIFI_IF | grep ether | awk '{print $2}')"
echo "Hostname: $(hostname)"
echo "College DNS: $(ipconfig getpacket $WIFI_IF | awk -F'[{},]' '/domain_name_server/{print $2}')"
echo ""

echo "=== Setup Partially Complete ==="
echo ""
echo "Next steps:"
echo "1. Fill in the team table with all machine IPs"
echo "2. Edit ~/cn-team.env with real values (replace CHANGE_ME)"
echo "3. Run: source ~/cn-team.env"
echo "4. Continue with manual steps from docs/1-mac1-dns-server.md"
echo ""
echo "Script completed successfully!"
