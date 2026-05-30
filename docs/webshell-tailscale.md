# WebShell And Tailscale

WebShell is the browser terminal for `claudebox`. It is exposed only on the
Tailscale address and is designed to survive browser refreshes by reattaching to
a persistent `tmux` session.

## URLs

| Thing | URL |
| --- | --- |
| WebShell | `http://100.100.196.79:4186/` |
| Registry UI | `http://100.100.196.79/` |
| Temporal UI | `http://100.100.196.79:8233/` |

The Tailscale IPv4 for this host is:

```bash
tailscale ip -4
```

## Architecture

```text
browser
  -> webshell-proxy.service on 100.100.196.79:4186
  -> webshell-ttyd.service on 127.0.0.1:4187
  -> /home/nick/Development/webshell/bin/webshell-mosh
  -> local mosh-client / mosh-server hop
  -> tmux session: webshell
```

The browser does not run Mosh directly. It talks to `ttyd` over WebSockets. The
PTY launched by `ttyd` runs the local Mosh hop, and Mosh attaches to the `tmux`
session.

## Services

```bash
systemctl status webshell-proxy.service --no-pager --lines=80
systemctl status webshell-ttyd.service --no-pager --lines=80
journalctl -u webshell-proxy.service -n 100 --no-pager
journalctl -u webshell-ttyd.service -n 100 --no-pager
```

Expected binds:

- `webshell-proxy.service`: `100.100.196.79:4186`
- `webshell-ttyd.service`: `127.0.0.1:4187`

Check them:

```bash
ss -ltnp '( sport = :4186 or sport = :4187 )'
```

## Mobile Notes

The proxy injects terminal smart keys and an in-page keyboard into the `ttyd`
page.

Use these URL flags when needed:

- `?vk=0`
- `?nativeKeyboard=1`

Both are useful when the native mobile keyboard behaves better than the injected
quickbar.

## Tailscale Binding Convention

Use `127.0.0.1` for private dependencies and admin APIs. Use `100.100.196.79`
for UIs that should be reachable from your tailnet devices.

For static apps created by the apphost registry, `0.0.0.0` is acceptable because
the registry owns the generated unit and the app is still intended for private
machine use.

Useful checks:

```bash
tailscale status
tailscale ip -4
ss -ltnp
curl -fsS http://100.100.196.79/
curl -fsS http://100.100.196.79:4186/ | sed -n '1,8p'
```
