# Phase 1 failure demonstrations

Run these from the client and save terminal output/screenshots under
`evidence/phase1/failures/`. Restore the live system after each test.

1. Wrong DNS server: temporarily set the client resolver to `8.8.8.8`; show that
   `dig app.$TEAM.test` fails while direct IP reachability still works.
2. Wrong A record: temporarily change the `app` record to an unused IP; show that
   `dig` succeeds but TCP to the returned address fails; restore the record.
3. One backend stopped: stop Backend A; repeat HTTPS requests and show only B;
   restart A and verify both return.
4. Both backends stopped: show DNS and TLS still work but nginx returns `502`;
   restart both.
5. Wrong port: request `https://app.$TEAM.test:9999`; show the TCP failure.

Record the exact commands, outputs, and observations for each scenario.
