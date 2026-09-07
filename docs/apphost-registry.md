# Apphost registry

Reviewed 2026-09-07 against source, installed helper help, and read-only API checks.

| Item | Location |
| --- | --- |
| Unit | `apphost-registry.service` |
| API | `http://127.0.0.1:9080/api/apps` |
| State | `/var/lib/apphost-registry/apps.sqlite3` |
| Source | `/home/nick/Development/apphost-registry/` |
| Binaries | `/usr/local/bin/apphost-registry`, `apphost-static-server`, `register-apphost-external` |
| Generated units | `/etc/systemd/system/apphost-<name>.service` |

Caddy proxies the full registry handler on the front door, including API
mutations. Loopback binding does not make the proxied API read-only. The HTTP
route has a tailnet/loopback address matcher; the HTTPS root lacks that matcher.
Inspect installed routes before assuming an access boundary.

## API

`GET /api/apps` returns an object containing an `apps` array with live systemd
status. `GET /healthz` checks the registry process. Existing app units can keep
running during a registry outage.

```bash
curl -fsS http://127.0.0.1:9080/healthz
curl -fsS http://127.0.0.1:9080/api/apps
```

For authorized static hosting, POST creates or updates a unit, reloads systemd,
enables/restarts it, and upserts the row. Example payload:

```json
{
  "name": "example",
  "description": "Example static tool",
  "directory": "/srv/example/dist",
  "scheme": "http",
  "host": "127.0.0.1",
  "port": 4180
}
```

The directory must exist. Names normalize to lowercase kebab-case, at most 64
characters. Scheme is http/https, host is an IP, and the port must be unique,
1–65535, excluding 80. Choose an intentional bind before posting.

## External services

Use the helper only to record an existing service:

```bash
register-apphost-external --name example --unit example.service \
  --directory /srv/example --description "Example tool" \
  --scheme http --host 127.0.0.1 --port 4181
```

It upserts a row; it has no delete flag. Use sudo only when authorized and needed
for database access. Registry restart acts on the row’s unit. DELETE assumes
`apphost-<name>.service`, so use it only for managed static apps. External-row
removal needs a reviewed SQLite change or a supported dedicated tool.
