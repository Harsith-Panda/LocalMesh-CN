#!/bin/bash
# Setup script for Ubuntu VM B (Backend B)
# This script automates the setup of Backend B on Ubuntu
# Usage: ./setup-ubuntu-vm-b.sh

set -e  # Exit on error

echo "=== Ubuntu VM B Backend B Setup ==="
echo ""

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This script must be run on Linux (Ubuntu)"
    exit 1
fi

# Check for root/sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script requires sudo privileges"
    sudo -v || exit 1
fi

# Step 1: Update package list
echo "Step 1: Updating package list..."
sudo apt update
echo "✓ Package list updated"
echo ""

# Step 2: Install Python 3
echo "Step 2: Installing Python 3..."
sudo apt install -y python3
python3 --version
echo "✓ Python 3 installed"
echo ""

# Step 3: Configure firewall
echo "Step 3: Configuring firewall..."
if command -v ufw &> /dev/null; then
    sudo ufw allow 3002/tcp
    echo "✓ Firewall configured (port 3002 allowed)"
else
    echo "⚠ UFW not found, skipping firewall configuration"
fi
echo ""

# Step 4: Create settings file template
echo "Step 4: Creating settings file template..."
cat > ~/cn-team.env <<'EOF'
export TEAM=teamX                # team name: lowercase letters/digits only, no spaces or _
export MAC1_IP=CHANGE_ME           # Mac 1: DNS
export MAC2_IP=CHANGE_ME           # Mac 2: nginx edge
export UBUNTU_VM_A_IP=CHANGE_ME   # Ubuntu VM A: Backend A
export UBUNTU_VM_B_IP=CHANGE_ME   # Ubuntu VM B: Backend B
export COLLEGE_DNS=8.8.8.8         # Mac 1's "DNS server" line from Step 3
EOF
echo "✓ Settings file template created at ~/cn-team.env"
echo "   Please edit this file with real values before continuing"
echo ""

# Step 5: Network info
echo "Step 5: Gathering network information..."
echo "IP: $(ip addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d'/' -f1)"
echo "Gateway: $(ip route show default | awk '{print $3}')"
echo "Hostname: $(hostname)"
echo ""

# Step 6: Create backend directory
echo "Step 6: Creating backend directory..."
mkdir -p ~/cn-backend
echo "✓ Backend directory created at ~/cn-backend"
echo ""

# Step 7: Instructions for app.py
echo "Step 7: Backend code setup"
echo "   Please copy app.py from backend-b/ folder to ~/cn-backend/"
echo "   The file should be: ~/cn-backend/app.py"
echo ""

echo "=== Setup Partially Complete ==="
echo ""
echo "Next steps:"
echo "1. Fill in the team table with all machine IPs"
echo "2. Edit ~/cn-team.env with real values (replace CHANGE_ME)"
echo "3. Run: source ~/cn-team.env"
echo "4. Copy app.py to ~/cn-backend/"
echo "5. Run: cd ~/cn-backend && python3 app.py"
echo "6. Continue with manual steps from docs/4-ubuntu-vm-b-backend.md"
echo ""
echo "Script completed successfully!"
