# Serve Skill

The Codex `serve` skill is the local runbook for hosting or exposing software on
this machine. Its source is:

```text
/home/nick/.codex/skills/serve/SKILL.md
```

Use it whenever work involves serving, hosting, exposing, publishing,
daemonizing, scheduling, delayed execution, retrying, or making software
reachable after the current agent turn.

## Policy

Use systemd as the source of truth for long-running software. Do not leave apps
running through `nohup`, shell job control, detached terminal sessions, `tmux`,
or one-off background commands when the app is expected to remain available.

Use the apphost registry as the inventory and front door for apps that should be
discoverable from the tailnet.

Use the local Temporal service for scheduled, delayed, retried, event-driven, or
workflow-like behavior. Do not introduce cron jobs, systemd timers, background
sleep loops, or ad hoc retry tables when Temporal is the better fit.

For new local services, tools, workers, and CLIs, use Go by default unless an
existing project already has a different stack or the user asks for a different
language.

## Machine Facts

| Item | Value |
| --- | --- |
| Public app host | `100.100.196.79` on `tailscale0` |
| Registry UI | `http://100.100.196.79/` |
| Registry API | `http://127.0.0.1:9080/api/apps` |
| Registry service | `apphost-registry.service` |
| Registry database | `/var/lib/apphost-registry/apps.sqlite3` |
| Registry-managed unit directory | `/etc/systemd/system` |
| Static server | `/usr/local/bin/apphost-static-server` |
| App user/group | `nick:nick` |
| Reserved port | `80` |
| Preferred project root | `/home/nick/Development` |

## Decision Tree

Use the registry API for static directories. It creates and manages an
`apphost-<name>.service` unit that serves files with
`apphost-static-server`.

Use a custom systemd unit for app servers, Docker services, workers, databases,
Temporal, or anything that is not a static directory. If it has a web UI, add an
informational registry row with `register-apphost-external`.

Do not use `POST /api/apps` to register a service that is already running on a
port. That endpoint creates a new static-server unit and will try to own the
port.

## Static App Flow

```bash
curl -fsS -X POST http://127.0.0.1:9080/api/apps \
  -H "Content-Type: application/json" \
  -d '{
    "name": "example",
    "description": "Example static app",
    "directory": "/home/nick/Development/example/dist",
    "host": "0.0.0.0",
    "port": 4180
  }'
```

Verify:

```bash
curl -fsS http://127.0.0.1:9080/api/apps
systemctl status apphost-example.service --no-pager --lines=80
curl -fsS http://100.100.196.79:4180/ | sed -n '1,8p'
```

## Custom Service Flow

Create the service file in the project first, then install it into
`/etc/systemd/system`.

```ini
[Unit]
Description=Example app
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=nick
Group=nick
WorkingDirectory=/home/nick/Development/example
Environment=PORT=4181
ExecStart=/usr/bin/npm start
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
```

Install and verify:

```bash
systemd-analyze verify example.service
sudo install -m 0644 example.service /etc/systemd/system/example.service
sudo systemctl daemon-reload
sudo systemctl enable --now example.service
systemctl status example.service --no-pager --lines=80
ss -ltnp '( sport = :4181 )'
```

Bind internal dependencies to `127.0.0.1` unless other machines need them. Bind
web UIs that should appear in the registry to `100.100.196.79`.

## External Registry Rows

Use `register-apphost-external` when a custom unit has a UI that should appear in
the registry:

```bash
register-apphost-external \
  --name example \
  --unit example.service \
  --description "Example app UI" \
  --directory /home/nick/Development/example \
  --host 100.100.196.79 \
  --port 4181
```

Run it with `sudo` if the registry database is not writable by the current user.

Manual registry rows are informational for non-`apphost-` units. Do not delete
them through the registry delete endpoint, because that path assumes
registry-managed `apphost-<name>.service` units.

## Temporal

The local Temporal dev server runs as `temporal-local.service`.

| Item | Value |
| --- | --- |
| Temporal gRPC | `127.0.0.1:7233` |
| Temporal UI | `http://100.100.196.79:8233/` |
| Docker image | `temporalio/temporal:latest` |
| Docker volume | `temporal-local-data` |

Checks:

```bash
systemctl status temporal-local.service --no-pager --lines=80
docker exec temporal-local temporal operator cluster health
curl -fsS http://100.100.196.79:8233/ | sed -n '1,8p'
```

Host Temporal workers with systemd like any other custom service.

## Done Means Verified

Before calling hosting work complete:

- `systemd-analyze verify <unit-file>` passes.
- `sudo systemctl enable --now <unit>` succeeds.
- `systemctl is-active <unit>` reports `active`.
- The expected port is listening on the intended address with `ss -ltnp`.
- The app returns an HTTP response or its domain-specific health check passes.
- `curl -fsS http://127.0.0.1:9080/api/apps` shows the registry row when the app
  should be discoverable.
