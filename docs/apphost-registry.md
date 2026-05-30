# Apphost Registry

Apphost Registry is the local systemd-backed inventory and launcher for web apps
on `claudebox`. It keeps a SQLite registry, renders a simple web UI, and can
create `apphost-<name>.service` units for static directories.

Source repository:

```text
/home/nick/Development/apphost-registry
```

## Runtime

| Item | Value |
| --- | --- |
| Registry service | `apphost-registry.service` |
| HTTP front door | `http://100.100.196.79/` |
| HTTPS front door | `https://claudebox.tail126557.ts.net/` |
| Local API | `http://127.0.0.1:9080/api/apps` |
| Database | `/var/lib/apphost-registry/apps.sqlite3` |
| Managed unit directory | `/etc/systemd/system` |
| Registry binary | `/usr/local/bin/apphost-registry` |
| Static server binary | `/usr/local/bin/apphost-static-server` |
| External helper | `/usr/local/bin/register-apphost-external` |

The registry API can mutate systemd and write unit files. Keep mutation endpoints
bound to localhost or a trusted private network.

## Service Commands

```bash
systemctl status apphost-registry.service --no-pager --lines=80
journalctl -u apphost-registry.service -f
curl -fsS http://127.0.0.1:9080/healthz
curl -fsS http://127.0.0.1:9080/api/apps
```

## API Shape

Rows returned from `GET /api/apps` include live systemd status:

```json
{
  "name": "example",
  "unit_name": "apphost-example.service",
  "description": "Example static app",
  "directory": "/home/nick/Development/example/dist",
  "scheme": "http",
  "host": "0.0.0.0",
  "port": 4180,
  "url": "http://100.100.196.79:4180/",
  "active": "active",
  "enabled": "enabled"
}
```

## Static App Registration

`POST /api/apps` creates or updates a registry-managed static app. The request
writes a systemd unit, reloads systemd, enables the unit, restarts it, and
upserts the SQLite row.

```bash
curl -fsS -X POST http://127.0.0.1:9080/api/apps \
  -H "Content-Type: application/json" \
  -d '{
    "name": "example",
    "description": "Example static app",
    "directory": "/home/nick/Development/example/dist",
    "scheme": "http",
    "host": "0.0.0.0",
    "port": 4180
  }'
```

Validation rules:

- `name` is normalized to lowercase kebab-case and limited to 64 characters.
- `directory` must already exist and must be a directory.
- `host` must be an IP address.
- `scheme` must be `http` or `https`.
- `port` must be unique in the registry, between `1` and `65535`, and cannot be
  `80`.

## External Services

App servers, workers, Docker services, databases, and other dynamic processes
should have their own systemd units. Add them to the registry only as
informational rows:

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

Use `sudo` if the registry database is not writable by the current user.

## Restart And Delete

Restart a managed app:

```bash
curl -fsS -X POST http://127.0.0.1:9080/api/apps/example/restart
```

Delete a registry-managed static app:

```bash
curl -fsS -X DELETE http://127.0.0.1:9080/api/apps/example
```

Only use delete for rows backed by `apphost-<name>.service`. External rows are
informational and should be removed with a helper or direct SQLite changes.

## Deploy Registry Changes

```bash
cd /home/nick/Development/apphost-registry
go build -o bin/apphost-registry ./cmd/apphost-registry
go build -o bin/apphost-static-server ./cmd/apphost-static-server
go build -o bin/register-apphost-external ./cmd/register-apphost-external
sudo install -m 0755 bin/apphost-registry /usr/local/bin/apphost-registry
sudo install -m 0755 bin/apphost-static-server /usr/local/bin/apphost-static-server
sudo install -m 0755 bin/register-apphost-external /usr/local/bin/register-apphost-external
sudo systemctl restart apphost-registry.service
```

## Caddy Front Door

The root host should serve the registry on ports `80` and `443`.

Expected behavior:

- `http://100.100.196.79/` routes to the registry.
- `https://claudebox.tail126557.ts.net/` routes to the registry.
- App-specific ports route to individual services.

Verify:

```bash
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl reload caddy
systemctl status caddy --no-pager --lines=80
curl -fsS http://100.100.196.79/ | sed -n '1,8p'
curl -fsS https://claudebox.tail126557.ts.net/ | sed -n '1,8p'
```
