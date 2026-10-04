#!/bin/bash
# Run on a Mac after source ~/cn-team.env and DNS points at Your Mac.
set -euo pipefail
source "$HOME/cn-team.env"
echo "Expected answer: $MANOHAR_MAC_IP"
dig app."$TEAM".test +short
dig api."$TEAM".test +short
dig google.com +short | head -n 1
