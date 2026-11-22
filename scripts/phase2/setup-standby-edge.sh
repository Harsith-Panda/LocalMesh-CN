#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
load_team
need_cmd brew
NGINX_ETC="${NGINX_ETC:-$(brew --prefix nginx)/etc/nginx}"
CONF="$NGINX_ETC/servers/localmesh-standby.conf"
CERT="${TLS_CERT:-$NGINX_ETC/certs/app.crt}"
KEY="${TLS_KEY:-$NGINX_ETC/certs/app.key}"
[[ -f "$CERT" && -f "$KEY" ]] || die "set TLS_CERT and TLS_KEY to certificate/key paths"
sudo mkdir -p "$NGINX_ETC/servers"
sudo tee "$CONF" >/dev/null <<EOF
upstream localmesh_standby_backends {
    server $YOUR_MAC_IP:3001 max_fails=1 fail_timeout=10s;
    server $YOUR_MAC_IP:3002 max_fails=1 fail_timeout=10s;
}
server {
    listen 8443 ssl http2;
    server_name app.$TEAM.test api.$TEAM.test;
    ssl_certificate $CERT;
    ssl_certificate_key $KEY;
    location / {
        proxy_pass http://localmesh_standby_backends;
        proxy_next_upstream error timeout http_502;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
echo "Standby nginx config written to $CONF"
echo "Validate with: nginx -t"
echo "Start only for the migration test; stop it afterward."
