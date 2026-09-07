# Tooling inventory

Reviewed 2026-09-07. Version observations are from about 00:52–00:56 UTC;
service observations are from about 15:42 UTC. No upgrades were performed.

## Versions

| Tool | Installed observation |
| --- | --- |
| Codex CLI / Codex ACP | 0.153.4 / 1.10.0 |
| Claude Code | 2.1.143 |
| Buzz release selection | 0.5.22 |
| Tailscale / Docker | 1.102.3 / 29.7.2 |
| GitHub CLI / Go | 2.45.0 / 1.22.2 |
| Node.js / npm / Python | 22.23.2 / 10.9.8 / 3.12.3 |
| Temporal CLI / server / UI | 1.7.0 / 1.31.0 / 2.49.1 |

Evidence came from each tool’s version output, global npm inventory, the Buzz
release symlink, and `docker exec temporal-local temporal --version`.
`buzz --version` is unsupported; inspect `/opt/buzz/current` instead. That
selection does not identify the separate native-root `buzz-acp` build.

## Services

These are system-level units. An unset `User=` defaults to root.

| Unit | Owner and connection |
| --- | --- |
| `apphost-registry.service` | root; loopback 9080 |
| `caddy.service` | Web front door; registry 80/443 and Buzz TLS 4193 |
| `webshell-proxy.service` | nick; tailnet 4186 → loopback 4187 |
| `webshell-ttyd.service` | nick; terminal backend |
| `webshell-watchdog.service` | root; terminal recovery |
| `temporal-local.service` | root launches Docker; loopback 7233, tailnet UI 8233 |
| `buzz-relay.service` | nick; main Compose stack |
| `buzz-pair-relay.service` | nick launches separate Docker container; tailnet 4192 |
| `buzz-agent.service`, `buzz-agent@.service` | [Agent roles and owners](buzz-agents.md) |
| `gardiner-maintenance@.service` | Privileged detached maintenance workers |

Registry, Temporal, and the three WebShell units were active. Morning checks
returned registry `ok: true` and Temporal `SERVING`; these are not end-to-end tests.

## Sources and state

| Area | Local authority |
| --- | --- |
| Agent instructions | `/home/nick/AGENTS.md` and repo-local instructions |
| Buzz deployment | `/home/nick/Development/buzz-host/` |
| Buzz harness exception | `/home/nick/Development/buzz/target/release/buzz-acp` |
| Codex config / skills | `/home/nick/.codex/` |
| Gardiner isolated home | `/var/lib/buzz-gardiner/` |
| Registry source / state | `/home/nick/Development/apphost-registry/`; `/var/lib/apphost-registry/apps.sqlite3` |
| WebShell source | `/home/nick/Development/webshell/` |
| Temporal installed unit / volume | `/etc/systemd/system/temporal-local.service`; `temporal-local-data` |
| Effective units / proxy | Installed unit files and drop-ins; `/etc/caddy/Caddyfile` |

Inspect installed definitions before trusting source copies. The older Buzz
skill reference called pairing a native process; the installed Docker unit takes
precedence. See [maintenance](maintenance-recovery.md) for the verified model
upgrade, historical pairing limitation, and dated reboot requirement.
