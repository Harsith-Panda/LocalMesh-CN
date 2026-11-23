#!/bin/bash
# Check that a saved capture contains the required DNS, TCP, and TLS evidence.
set -euo pipefail
PCAP="${1:?usage: $0 path/to/flow.pcap}"
TSHARK="${TSHARK:-/Applications/Wireshark.app/Contents/MacOS/tshark}"
[[ -x "$TSHARK" ]] || TSHARK=tshark
echo '--- protocol counts ---'
$TSHARK -r "$PCAP" -q -z io,phs | grep -E 'dns|tcp|tls' || true
echo '--- DNS queries ---'
$TSHARK -r "$PCAP" -Y 'dns.flags.response == 0' -T fields \
  -e frame.number -e ip.src -e ip.dst -e dns.qry.name
echo '--- TCP handshake / TLS packets ---'
$TSHARK -r "$PCAP" -Y 'tcp.flags.syn == 1 or tls' -T fields \
  -e frame.number -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e _ws.col.Info
if ! $TSHARK -r "$PCAP" -Y 'tcp.flags.syn == True && tcp.flags.ack == True' \
  -T fields -e frame.number 2>/dev/null | grep -q .; then
  echo 'ERROR: no SYN-ACK found; capture is not valid Task G evidence.' >&2
  exit 1
fi
if ! $TSHARK -r "$PCAP" -Y 'tls.handshake.type == 1 or tls.handshake.type == 2 or tls.handshake.type == 11' \
  -T fields -e frame.number 2>/dev/null | grep -q .; then
  echo 'ERROR: no TLS handshake packets found; capture is not valid Task G evidence.' >&2
  exit 1
fi
if ! $TSHARK -r "$PCAP" -Y 'dns.qry.name == "app.localmesh.test"' \
  -T fields -e frame.number 2>/dev/null | grep -q .; then
  echo 'ERROR: no DNS query for app.localmesh.test found; recapture after flushing DNS.' >&2
  exit 1
fi
if ! $TSHARK -r "$PCAP" -Y 'dns.flags.response == 1 && dns.qry.name == "app.localmesh.test"' \
  -T fields -e frame.number 2>/dev/null | grep -q .; then
  echo 'ERROR: no DNS response for app.localmesh.test found; recapture the DNS exchange.' >&2
  exit 1
fi
echo 'PASS: DNS/TCP/TLS evidence is present.'
