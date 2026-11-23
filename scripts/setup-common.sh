#!/usr/bin/env bash

# Shared validation for the role setup scripts.
# This file intentionally never creates or edits ~/cn-team.env.

set -euo pipefail

require_team_env() {
  local env_file="$HOME/cn-team.env"
  if [[ ! -f "$env_file" ]]; then
    echo "ERROR: $env_file does not exist." >&2
    echo "Create it with the current team IPs, then run: source $env_file" >&2
    exit 1
  fi

  # shellcheck disable=SC1090
  source "$env_file"
  local name value
  for name in TEAM YOUR_MAC_IP MANOHAR_MAC_IP COLLEGE_DNS; do
    value="${!name:-}"
    if [[ -z "$value" || "$value" == *CHANGE_ME* || "$value" == *'<'* || "$value" == *'>'* ]]; then
      echo "ERROR: $name is missing or still a placeholder in $env_file" >&2
      exit 1
    fi
  done

  export TEAM YOUR_MAC_IP MANOHAR_MAC_IP COLLEGE_DNS
  echo "Using existing settings: TEAM=$TEAM YOUR_MAC_IP=$YOUR_MAC_IP MANOHAR_MAC_IP=$MANOHAR_MAC_IP COLLEGE_DNS=$COLLEGE_DNS"
}
