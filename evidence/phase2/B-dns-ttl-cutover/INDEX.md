# Extension B — DNS TTL and controlled record change

- [ ] `B1-ttl-before-YYYY-MM-DD.png` — `dig` shows the configured short TTL.
- [ ] `B2-record-before-YYYY-MM-DD.txt` or `.png` — original A record.
- [ ] `B3-record-changed-YYYY-MM-DD.txt` or `.png` — authoritative answer after controlled change.
- [ ] `B4-cached-old-answer-YYYY-MM-DD.png` — client still uses old answer before expiry.
- [ ] `B5-after-expiry-or-flush-YYYY-MM-DD.png` — client receives new answer.
- [ ] `B6-record-restored-YYYY-MM-DD.png` — original record restored.
- [ ] `B7-ttl-pcap-YYYY-MM-DD.pcap` — optional DNS cutover capture.

Include the exact TTL, change time, expiry time, cache-flush command, and restored value.
