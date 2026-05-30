# Codex Local Workflow

This box has machine-level agent instructions at:

```text
/home/nick/AGENTS.md
```

The key idea is simple: short-lived commands are fine for builds, tests, and
inspection. Anything that should stay available after the current turn belongs
in systemd.

## Working Directory

Use `/home/nick/Development` for projects and local tools unless there is a
specific reason to work elsewhere.

Before editing an existing project, inspect the repo shape and current changes:

```bash
pwd
git status --short
rg --files | sed -n '1,120p'
```

Use `rg` first for text search. It is faster and usually clearer than `grep`.

## File Edits

Keep edits scoped to the requested behavior and the local conventions already in
the repo.

Prefer structured APIs and parsers over ad hoc string manipulation when the
language or codebase provides them.

Do not revert user changes unless explicitly asked. If unrelated files are dirty,
leave them alone.

## Persistent Services

When building or exposing something that should keep running:

1. Create a service file with `WorkingDirectory`, `ExecStart`, environment, and
   `Restart=on-failure`.
2. Verify it with `systemd-analyze verify`.
3. Install it into the correct systemd unit directory.
4. Reload systemd.
5. Enable and start the unit.
6. Check logs, status, bind address, and an HTTP or domain health check.
7. Add an apphost registry row if it should appear in the local app inventory.

System-level units normally live in:

```text
/etc/systemd/system
```

User-level units normally live in:

```text
~/.config/systemd/user
```

Prefer user-level units unless the service needs system privileges, Docker,
boot-level behavior, or established apphost registry conventions.

## Verification

Common checks:

```bash
systemd-analyze verify <unit-file>
systemctl status <unit> --no-pager --lines=80
journalctl -u <unit> -n 100 --no-pager
systemctl is-active <unit>
systemctl is-enabled <unit>
ss -ltnp '( sport = :<port> )'
curl -fsS http://127.0.0.1:<port>/ || true
curl -fsS http://100.100.196.79:<port>/ || true
```

For registry-discoverable apps:

```bash
curl -fsS http://127.0.0.1:9080/api/apps
```

## Git Safety

Use non-interactive commands where possible:

```bash
git status --short
git diff -- README.md docs
git add README.md docs
git commit -m "Update documentation"
git push
```

Avoid destructive commands such as `git reset --hard` or `git checkout --` unless
the user clearly asks for them.
