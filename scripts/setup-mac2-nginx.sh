#!/bin/bash
# Setup script for Manohar's Mac (nginx Edge & TLS)
# This script automates the setup of nginx and TLS certificates on Manohar's Mac
# Usage: ./setup-mac2-nginx.sh

set -e  # Exit on error

echo "=== Manohar's Mac nginx Edge & TLS Setup ==="
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

# Step 2: Install nginx
echo "Step 2: Installing nginx..."
brew install nginx
NGINX_DIR="$(brew --prefix)/etc/nginx"
cp "$NGINX_DIR/nginx.conf" "$NGINX_DIR/nginx.conf.backup"
mkdir -p "$NGINX_DIR/servers" "$NGINX_DIR/certs"
echo "✓ nginx installed"
echo ""

# Step 3: Create settings file template
echo "Step 3: Creating settings file template..."
cat > ~/cn-team.env <<'EOF'
export TEAM=localmesh
export YOUR_MAC_IP=10.7.12.104
export MANOHAR_MAC_IP=10.7.2.38
export COLLEGE_DNS=8.8.8.8
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
echo ""

echo "=== Setup Partially Complete ==="
echo ""
echo "Next steps:"
echo "1. Fill in the team table with Mac IPs"
echo "2. Edit ~/cn-team.env with real values (replace CHANGE_ME)"
echo "3. Run: source ~/cn-team.env"
echo "4. Continue with manual steps from docs/2-mac2-nginx-edge.md"
echo "   - Certificate generation (Step 7)"
echo "   - nginx configuration (Step 8)"
echo "   Note: nginx upstream will point to YOUR_MAC_IP:3001 and YOUR_MAC_IP:3002"
echo ""
echo "Script completed successfully!"
