# WebShell and Tailscale

Reviewed 2026-09-07 against source and installed units.

```text
Browser → tailnet :4186 proxy → loopback :4187 ttyd
        → local Mosh hop → persistent tmux session
```

The browser uses WebSockets, not Mosh directly. The PTY runs Mosh locally;
tmux preserves shell state across browser reconnects. Proxy and ttyd run as
nick under systemd. Source: `/home/nick/Development/webshell/`.

Touch clients use the native keyboard by default. `?vk=1` enables the injected
keyboard; the smart-key bar remains available.

## Recovery

The root-owned watchdog checks service state, proxy HTTP, ttyd’s token endpoint,
and WebSocket behavior. Its configured interval is 45 seconds, failure threshold
two, and cooldown two minutes. Backend/WebSocket failures restart ttyd and proxy;
proxy-only failures restart the proxy. HTTP 200 alone does not prove a terminal
works.

```bash
systemctl status webshell-proxy.service webshell-ttyd.service --no-pager
journalctl -u webshell-watchdog.service --no-pager -n 100
ss -ltn '( sport = :4186 or sport = :4187 )'
tailscale ip -4
```

Use loopback for internal dependencies and the tailnet address for private UIs.
An all-interface bind is not made private by apphost ownership. Check routing,
firewall, and proxy access controls. A persistent terminal is not a substitute
for [systemd application hosting](serve-skill.md).
