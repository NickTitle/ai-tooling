# Utilities On This Box

Last updated: 2026-05-30

Imported from gist:

```text
https://gist.github.com/OWNER/GIST_ID
```

This note is an operator map for `claudebox`, the Linux host under `/home/nick`.
It focuses on the local hosting stack, the web shell, Tailscale access, and the
commands that are useful when building or debugging projects here.

## Quick Map

| Thing | Value |
| --- | --- |
| Main user | `nick` |
| Workspace | `/home/nick/Development` |
| Tailscale IPv4 | `100.100.196.79` |
| Tailnet DNS host | `claudebox.tail126557.ts.net` |
| App registry UI | `http://100.100.196.79/` or `https://claudebox.tail126557.ts.net/` |
| App registry API | `http://127.0.0.1:9080/api/apps` |
| WebShell | `http://100.100.196.79:4186/` |
| Temporal UI | `http://100.100.196.79:8233/` |

## The Shell

There are two shell contexts worth keeping separate:

- The browser shell is WebShell, a persistent terminal served over Tailscale.
  It lives at `http://100.100.196.79:4186/`.
- Agent command runs are short-lived Bash commands launched from the current
  workspace, usually `/home/nick`. They are good for builds, tests, inspection,
  and one-off scripts. Persistent apps should be promoted to systemd services.

WebShell is backed by these systemd units:

```bash
systemctl status webshell-proxy.service --no-pager --lines=80
systemctl status webshell-ttyd.service --no-pager --lines=80
journalctl -u webshell-proxy.service -n 100 --no-pager
journalctl -u webshell-ttyd.service -n 100 --no-pager
```

Runtime shape:

- `webshell-proxy.service` listens on `100.100.196.79:4186`.
- `webshell-ttyd.service` listens only on `127.0.0.1:4187`.
- `ttyd` starts `/home/nick/Development/webshell/bin/webshell-mosh`.
- The local Mosh hop attaches to `/usr/bin/tmux -u new-session -A -s webshell`.
- Refreshing the browser should reattach the same `tmux` session.
- Add `?vk=0` or `?nativeKeyboard=1` to the WebShell URL to bypass the custom
  mobile keyboard behavior.

Useful installed shell tools include:

```bash
rg                  # fast text search
gh                  # GitHub CLI, authenticated with gist/repo scopes
tailscale           # tailnet status and IPs
tmux                # persistent terminal sessions
mosh-client         # resilient local hop used by WebShell
go                  # Go toolchain
node && npm         # Node.js tooling
python3             # Python 3
docker              # container runtime
```

Observed versions on 2026-05-29:

```text
Bash 5.2.21
tmux 3.4
gh 2.45.0
Tailscale 1.98.2
Go 1.22.2
Node 22.22.2
npm 11.15.0
Python 3.12.3
Docker 29.5.0
```

## Tailscale

Tailscale is the private network path into this machine. The stable IPv4 address
for this host is:

```bash
tailscale ip -4
# 100.100.196.79
```

Use the Tailscale IP or tailnet DNS name for apps that should be reachable from
your devices:

- `http://100.100.196.79:<port>/`
- `https://claudebox.tail126557.ts.net:<port>/`

Binding convention:

- Bind private dependencies and admin APIs to `127.0.0.1`.
- Bind web UIs intended for your tailnet to `100.100.196.79` or `0.0.0.0`,
  depending on the app and registry path.
- Port `80` is reserved for the apphost registry front door.

Useful checks:

```bash
tailscale ip -4
tailscale status
ss -ltnp
curl -fsS http://100.100.196.79/
```

## Hosting Policy

Anything that should remain available after an agent turn should run under
systemd. Do not leave hosted apps running only through `nohup`, shell job
control, a detached tool session, `tmux`, or `setsid`.

Prefer user services in `~/.config/systemd/user/` when possible. Use system
units in `/etc/systemd/system/` when the service needs privileged ports, Docker,
machine-level boot behavior, or the existing apphost conventions.

Basic system service workflow:

```bash
systemd-analyze verify example.service
sudo install -m 0644 example.service /etc/systemd/system/example.service
sudo systemctl daemon-reload
sudo systemctl enable --now example.service
systemctl status example.service --no-pager --lines=80
journalctl -u example.service -n 100 --no-pager
ss -ltnp '( sport = :4181 )'
```

## Apphost Registry

The apphost registry is the local app inventory and front door. It keeps a SQLite
database of apps, renders a simple web UI, and can create systemd services for
static directories.

Runtime facts:

| Item | Value |
| --- | --- |
| Registry service | `apphost-registry.service` |
| Registry source | `/home/nick/Development/apphost-registry` |
| Registry binary | `/usr/local/bin/apphost-registry` |
| Static server binary | `/usr/local/bin/apphost-static-server` |
| External row helper | `/usr/local/bin/register-apphost-external` |
| API bind | `127.0.0.1:9080` |
| Database | `/var/lib/apphost-registry/apps.sqlite3` |
| Managed unit dir | `/etc/systemd/system` |
| Static unit naming | `apphost-<name>.service` |
| Static app user/group | `nick:nick` |

Service checks:

```bash
systemctl status apphost-registry.service --no-pager --lines=80
journalctl -u apphost-registry.service -n 100 --no-pager
curl -fsS http://127.0.0.1:9080/api/apps
```

### Register A Static Directory

Use the registry API for static sites or built assets. The registry writes an
`apphost-<name>.service` unit, starts it, enables it, and records it in SQLite.

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

Then verify:

```bash
systemctl status apphost-example.service --no-pager --lines=80
curl -fsS http://100.100.196.79:4180/ | sed -n '1,8p'
curl -fsS http://127.0.0.1:9080/api/apps
```

### Register An External Service

Use a custom systemd unit for app servers, Docker services, workers, databases,
or anything that is not a plain static directory. After the unit exists and is
healthy, add an informational registry row:

```bash
register-apphost-external \
  --name example-api \
  --unit example-api.service \
  --description "Example API" \
  --directory /home/nick/Development/example-api \
  --scheme http \
  --host 100.100.196.79 \
  --port 4181
```

Run the helper with `sudo` if the registry database is not writable by the
current user.

Important: do not use the registry delete endpoint for externally managed
services. That endpoint assumes registry-managed `apphost-<name>.service` units.

## Temporal

Temporal is the local workflow engine to use for delayed, scheduled, retried, or
long-running workflow-like behavior. Prefer this over cron jobs, background
sleep loops, or ad hoc retry tables when workflow semantics matter.

Runtime facts:

| Item | Value |
| --- | --- |
| Service | `temporal-local.service` |
| Docker container | `temporal-local` |
| Persistent volume | `temporal-local-data` |
| gRPC endpoint | `127.0.0.1:7233` |
| UI | `http://100.100.196.79:8233/` |

Checks:

```bash
systemctl status temporal-local.service --no-pager --lines=80
docker exec temporal-local temporal operator cluster health
curl -fsS http://100.100.196.79:8233/ | sed -n '1,8p'
```

Host Temporal workers as ordinary systemd services and point clients/workers at
`127.0.0.1:7233`.

## GitHub And Gists

The GitHub CLI is installed and authenticated as `NickTitle` with `gist` scope.

Useful commands:

```bash
gh auth status
gh gist list --limit 10
gh gist create ./box-utilities.md --desc "Utilities on claudebox"
gh gist edit <gist-id> ./box-utilities.md
```

This `gh` install creates secret gists by default. Use `--public` only for notes
that are safe to list publicly.

## Debugging Checklist

For any hosted app:

```bash
systemctl status <unit> --no-pager --lines=80
journalctl -u <unit> -n 100 --no-pager
systemctl is-active <unit>
systemctl is-enabled <unit>
ss -ltnp '( sport = :<port> )'
curl -fsS http://127.0.0.1:<port>/ || true
curl -fsS http://100.100.196.79:<port>/ || true
curl -fsS http://127.0.0.1:9080/api/apps
```

For static apps managed by the registry, check the generated unit:

```bash
systemctl cat apphost-<name>.service
```

For external services, check the project-owned unit file and the registry row:

```bash
systemctl cat <unit>
curl -fsS http://127.0.0.1:9080/api/apps
```
