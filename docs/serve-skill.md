# Hosting

Reviewed 2026-09-07 against the local `serve` skill and service definitions.
Use systemd for persistent processes, apphost for discovery, and local Temporal
for durable scheduled, delayed, or retried work. Prefer Go for new local tools
unless an existing stack or owner choice applies.

## Choose the service

| Need | Use |
| --- | --- |
| Static directory | [Registry API](apphost-registry.md) |
| Server, worker, database, Docker service | Custom systemd unit |
| Existing service with a web UI | External registry row |
| Durable scheduled work | Temporal workflow and systemd worker |

Do not register a running server through the static-app POST endpoint; it would
create a competing listener. Do not leave persistent apps in ad hoc background
shells. Existing infrastructure heartbeats/watchdogs are not replacements for
durable application scheduling.

For custom units, define owner, working directory, ExecStart, dependencies, and
restart policy. Check syntax, install through the established systemd workflow,
then verify service state, intended bind, and domain health. Add a registry row
when discovery is useful. Deployment commands require deployment scope.

Bind internal APIs to loopback and tailnet-only UIs to the tailnet address.
`0.0.0.0` binds all IPv4 interfaces; access controls determine reachability.

## Temporal

`temporal-local.service` launches Docker `server start-dev`. It persists SQLite
at `/var/lib/temporal-local/temporal.db` in `temporal-local-data`. The unit prepares
volume ownership first. Its mutable `temporalio/temporal:latest` tag does not
prove a recent pull or a production deployment.

Workers/clients use `127.0.0.1:7233`; the UI uses tailnet port 8233. Application
workers are separate services and must poll the correct queue. Example
architecture: web app → Temporal server ← workflow worker. A working page or UI
does not prove worker processing.

```bash
systemctl status temporal-local.service --no-pager
docker exec temporal-local temporal operator cluster health
```

Preserve the volume and worker configuration during recovery. Check workflow
progress as well as server health. No service-changing example was run for this
review.
