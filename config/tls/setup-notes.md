# TLS notes — team localmesh

Created on Manohar's Mac (`10.7.2.38`).

- CA CN: `localmesh Local Root CA` (`~/team-certs/team-CA.pem`)
- Server CN/SAN: `app.localmesh.test`, `api.localmesh.test`
- nginx: `$(brew --prefix)/etc/nginx/certs/app.crt` + `app.key`
- Clients trust `team-CA.pem` (macOS System keychain / Ubuntu `update-ca-certificates`)
- Use `/usr/bin/curl` on macOS. Do not use `-k` for evidence.
- Do not submit `team-CA.key` or `app.key`.
