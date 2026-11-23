#!/bin/bash
# Setup script for Your Mac (DNS Server)
# This script automates the setup of dnsmasq on Your Mac
# Usage: ./setup-mac1-dns.sh

set -e  # Exit on error
source "$(dirname "$0")/setup-common.sh"

echo "=== Your Mac DNS Server Setup ==="
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

# Step 1: Use the existing team settings; never overwrite them.
echo "Step 1: Loading existing team settings..."
require_team_env
echo ""

# Step 2: Install dnsmasq
echo "Step 2: Installing dnsmasq..."
brew list dnsmasq >/dev/null 2>&1 || brew install dnsmasq
DNSMASQ_CONF="$(brew --prefix)/etc/dnsmasq.conf"
[[ -f "$DNSMASQ_CONF" && ! -f "$DNSMASQ_CONF.backup" ]] && cp "$DNSMASQ_CONF" "$DNSMASQ_CONF.backup"
echo "✓ dnsmasq installed"
echo ""

# Step 3: Network info
echo "Step 3: Gathering network information..."
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
echo "1. Confirm the existing ~/cn-team.env contains current IPs"
echo "2. Run: source ~/cn-team.env"
echo "3. Continue with manual steps from docs/1-mac1-dns-server.md"
echo ""
echo "Script completed successfully!"
