# LocalMesh from scratch: Phase 1 to Phase 2

This guide starts from an empty setup and builds the current Option A topology. It uses the repository scripts, but explains the manual steps that the scripts cannot safely automate.

## Topology and values

Use two physical Macs on the same private Wi-Fi/LAN:

- Your Mac / Mac 1: private DNS and UTM host.
- Manohar's Mac / Mac 2: nginx edge, TLS, and load balancer.
- Ubuntu VM with UTM host port 3001: Backend A.
- Ubuntu VM named LocalMesh - 1 with UTM host port 3002: Backend B.

The client path is:

    client -> dnsmasq on Mac 1 -> app.localmesh.test
           -> nginx on Mac 2:8443 -> Mac 1:3001 or :3002 -> UTM backend

Use physical Mac IPs in configurations. Do not use guest VM IPs in nginx.

Before starting, record:

~~~
TEAM=localmesh
YOUR_MAC_IP=<Your Mac Wi-Fi IPv4 address>
MANOHAR_MAC_IP=<Manohar's Mac Wi-Fi IPv4 address>
COLLEGE_DNS=8.8.8.8
~~~

Keep the IPs stable if possible. Disable VPN, iCloud Private Relay, and DNS-routing tools during setup.

## 1. Prepare each machine

Copy or clone this repository onto both Macs and both Ubuntu VMs. On every machine,
create the settings file only if it does not already exist:

~~~
cd /path/to/LocalMesh
chmod +x scripts/*.sh scripts/phase2/*.sh
if [[ ! -f ~/cn-team.env ]]; then cat > ~/cn-team.env <<'EOF'
export TEAM=localmesh
export YOUR_MAC_IP=<Your-Mac-Wi-Fi-IP>
export MANOHAR_MAC_IP=<Manohar-Mac-Wi-Fi-IP>
export COLLEGE_DNS=8.8.8.8
EOF
fi
source ~/cn-team.env
echo "$TEAM $YOUR_MAC_IP $MANOHAR_MAC_IP $COLLEGE_DNS"
~~~

Replace the placeholders; do not type the angle brackets.

## 2. Configure UTM

Shut down both Ubuntu VMs. In UTM, open Network settings and choose Emulated VLAN.

For the VM running Backend A:

- TCP host address: YOUR_MAC_IP
- TCP host port: 3001
- TCP guest port: 3001
- Guest address: empty

For LocalMesh - 1 running Backend B:

- TCP host address: YOUR_MAC_IP
- TCP host port: 3002
- TCP guest port: 3002
- Guest address: empty

Boot both VMs. Guest addresses are only for VM administration. Test published services through YOUR_MAC_IP:3001 and YOUR_MAC_IP:3002.

## 3. Configure both backends

On the Backend A VM:

~~~
./scripts/setup-phase1.sh backend-a
cp backend-a/app.py ~/cn-backend/app.py
cd ~/cn-backend
python3 app.py
~~~

On the Backend B VM:

~~~
./scripts/setup-phase1.sh backend-b
cp backend-b/app.py ~/cn-backend/app.py
cd ~/cn-backend
python3 app.py
~~~

If the repository is not inside the VM, copy the matching app.py with SCP or a UTM shared folder. Keep both processes running.

Test locally:

~~~
curl -i http://127.0.0.1:3001/api/status
curl -i http://127.0.0.1:3002/api/status
~~~

From a physical Mac, test UTM forwarding:

~~~
curl -i http://$YOUR_MAC_IP:3001/api/status
curl -i http://$YOUR_MAC_IP:3002/api/status
~~~

Both must return 200 and the correct X-Backend header.

## 4. Configure Mac 1 DNS

On Your Mac:

~~~
./scripts/setup-phase1.sh dns
source ~/cn-team.env
DNSMASQ_CONF="$(brew --prefix)/etc/dnsmasq.conf"
cp "$DNSMASQ_CONF" "$DNSMASQ_CONF.phase1-backup"
cat > "$DNSMASQ_CONF" <<EOF
listen-address=127.0.0.1,$YOUR_MAC_IP
bind-interfaces
no-resolv
server=$COLLEGE_DNS
server=1.1.1.1
local=/$TEAM.test/
host-record=app.$TEAM.test,$MANOHAR_MAC_IP
host-record=api.$TEAM.test,$MANOHAR_MAC_IP
domain-needed
bogus-priv
log-queries
EOF
sudo dnsmasq --test --conf-file="$DNSMASQ_CONF"
sudo brew services restart dnsmasq
sudo networksetup -setdnsservers Wi-Fi "$YOUR_MAC_IP"
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
dig @127.0.0.1 app.$TEAM.test +short
dig @"$YOUR_MAC_IP" app.$TEAM.test +short
~~~

Both names must resolve to MANOHAR_MAC_IP.

## 5. Configure Mac 2 nginx and TLS

On Manohar's Mac:

~~~
./scripts/setup-phase1.sh edge
source ~/cn-team.env
NGINX_DIR="$(brew --prefix)/etc/nginx"
mkdir -p "$NGINX_DIR/servers" "$NGINX_DIR/certs" ~/team-certs
~~~

Create the local CA and server certificate:

~~~
cd ~/team-certs
openssl genrsa -out team-CA.key 4096
openssl req -x509 -new -nodes -key team-CA.key -sha256 -days 365 \
  -out team-CA.pem -subj "/CN=$TEAM Local Root CA"
openssl genrsa -out app.key 2048
openssl req -new -key app.key -out app.csr -subj "/CN=app.$TEAM.test"
cat > app.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
subjectAltName=DNS:app.$TEAM.test,DNS:api.$TEAM.test
EOF
openssl x509 -req -in app.csr -CA team-CA.pem -CAkey team-CA.key \
  -CAcreateserial -out app.crt -days 365 -sha256 -extfile app.ext
openssl verify -CAfile team-CA.pem app.crt
cp app.crt app.key "$NGINX_DIR/certs/"
chmod 600 "$NGINX_DIR/certs/app.key"
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain ~/team-certs/team-CA.pem
~~~

Copy team-CA.pem to Mac 1 and both VMs. Trust it on Mac 1 with security add-trusted-cert. On each Ubuntu VM:

~~~
sudo cp team-CA.pem /usr/local/share/ca-certificates/localmesh-team-CA.crt
sudo update-ca-certificates
~~~

Verify the Homebrew nginx config includes its server snippets:

~~~
grep 'include servers' "$NGINX_DIR/nginx.conf"
~~~

Copy and substitute the repository nginx configs:

~~~
cp config/nginx/team-http.conf "$NGINX_DIR/servers/team-http.conf"
cp config/nginx/team-https.conf "$NGINX_DIR/servers/team-https.conf"
sed -i '' -e "s/TEAM/$TEAM/g" -e "s/YOUR_MAC_IP/$YOUR_MAC_IP/g" \
  "$NGINX_DIR/servers/team-http.conf" "$NGINX_DIR/servers/team-https.conf"
nginx -t
brew services restart nginx
~~~

## 6. Point clients at Mac 1 DNS

On Mac 2:

~~~
sudo networksetup -setdnsservers Wi-Fi "$YOUR_MAC_IP"
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
~~~

On both Ubuntu VMs:

~~~
sudo sed -i "s/nameserver.*/nameserver $YOUR_MAC_IP/" /etc/resolv.conf
~~~

From Mac 2 and both VMs:

~~~
dig app.$TEAM.test +short
dig app.$TEAM.test | grep SERVER
/usr/bin/curl -sv https://app.$TEAM.test:8443/api/status
~~~

The DNS answer must be MANOHAR_MAC_IP, HTTPS must validate without -k, and the response must contain X-Backend.

## 7. Complete the Phase 1 gate

Run:

~~~
./scripts/test-dns.sh
./scripts/test-backend.sh
./scripts/test-https.sh
./scripts/test-load-balancing.sh
./scripts/test-cache.sh
~~~

The cache script should show Cache-Control, ETag, and eventually 304.

Capture a clean packet flow. On a client with Wi-Fi interface en0:

~~~
export CAPTURE_IFACE=en0
./scripts/capture-phase1-flow.sh evidence/phase1/tcp/phase1-flow.pcap
~~~

While it captures, make one request in another terminal:

~~~
/usr/bin/curl -sv https://app.$TEAM.test:8443/api/status
~~~

Stop with Ctrl-C and validate:

~~~
./scripts/verify-phase1-flow.sh evidence/phase1/tcp/phase1-flow.pcap
~~~

Open the capture in Wireshark and save screenshots for DNS query/response, TCP SYN/SYN-ACK/ACK, and TLS ClientHello/ServerHello/Certificate.

Run all five deliberate failures from:

~~~
scripts/test-failure-scenarios.md
~~~

Do not start Phase 2 until Phase 1 has the complete pcap, cache proof, and F1-F5 evidence in evidence/phase1/.

## 8. Phase 2 execution

Read phase2-plan.md before making changes. Phase 2 extends the Phase 1 system.

### Extension A: backup DNS

On Mac 2:

~~~
./scripts/phase2/setup-backup-dns.sh
./scripts/phase2/start-backup-dns.sh
~~~

Configure clients with both YOUR_MAC_IP and MANOHAR_MAC_IP as DNS servers. Test:

~~~
./scripts/phase2/test-dns-failover.sh "$YOUR_MAC_IP" "$MANOHAR_MAC_IP"
~~~

Stop primary dnsmasq, repeat the test, then restart it and restore primary-first resolver order. Stop backup DNS after the demonstration:

~~~
./scripts/phase2/stop-backup-dns.sh
~~~

### Extension B: TTL and DNS cutover

On Mac 1:

~~~
./scripts/phase2/configure-ttl.sh 30
sudo brew services restart dnsmasq
~~~

Change only to a controlled standby address:

~~~
./scripts/phase2/set-dns-record.sh <standby-edge-IP>
sudo brew services restart dnsmasq
./scripts/phase2/test-ttl-cutover.sh app.$TEAM.test 30
~~~

Restore the backed-up dnsmasq configuration and restart it after testing.

### Extension D: backend failover

Capture healthy A/B responses, stop Backend A, and run:

~~~
./scripts/phase2/test-backend-failover.sh
~~~

All successful responses should be Backend B. Restart Backend A and verify A/B distribution resumes.

### Extension E: standby edge migration

Copy the public CA and server certificate/key to the temporary standby Mac. Set their paths:

~~~
export TLS_CERT=/path/to/app.crt
export TLS_KEY=/path/to/app.key
./scripts/phase2/setup-standby-edge.sh
nginx -t
~~~

Start standby nginx only for the migration test. Change DNS to its address and run:

~~~
./scripts/phase2/test-edge-migration.sh
~~~

Restore DNS to Mac 2 and stop standby nginx.

### Extension C: service isolation

On Your Mac, preview first:

~~~
./scripts/phase2/apply-backend-isolation.sh
~~~

After saving the rollback path and confirming nginx can reach both backends:

~~~
./scripts/phase2/apply-backend-isolation.sh --apply
~~~

Verify the edge still works and a non-edge client cannot connect directly to ports 3001/3002. Restore immediately:

~~~
./scripts/phase2/rollback-backend-isolation.sh /path/to/pf.conf.before
~~~

### Extension F: troubleshooting

Run the diagnostic sequence:

~~~
./scripts/phase2/diagnose.sh
~~~

Always check DNS, then TCP, then TLS, then the application. Save the injected fault, output, affected layer, fix, and final result.

## 9. Evidence and cleanup

Keep Phase 1 and Phase 2 evidence separate:

~~~
evidence/phase1/
evidence/phase2/
~~~

At the end of a session:

~~~
# macOS
sudo networksetup -setdnsservers Wi-Fi empty
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Ubuntu
sudo sed -i 's/nameserver.*/nameserver 8.8.8.8/' /etc/resolv.conf
~~~

Stop nginx, dnsmasq, backup DNS, both backend processes, and any standby edge. Keep team-CA.key, app.key, and firewall backups out of the repository.

## 10. Final checklist

- Phase 1 DNS, HTTPS, load balancing, cache, packet, and failure evidence exists.
- Phase 2 Extensions A-F each have configuration, before/after proof, and rollback proof.
- Phase 1 and Phase 2 pcaps are separate.
- No private key or personal machine secret is submitted.
- Both team members can explain DNS, TCP, TLS, HTTP caching, load balancing, TTL, isolation, failover, migration, and troubleshooting.

