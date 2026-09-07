# Common checks

Use [inventory](machine-inventory.md) for dated versions and source locations.
These checks do not change services:

```bash
systemctl status apphost-registry.service temporal-local.service --no-pager
systemctl list-units 'buzz-agent*' --all --no-pager
systemctl list-unit-files 'buzz-agent*' --no-pager
curl -fsS http://127.0.0.1:9080/healthz
docker exec temporal-local temporal operator cluster health
tailscale ip -4
```

Use bounded `journalctl -u UNIT --no-pager -n 100` reads for the affected layer.
Respect journal permissions. Share only the evidence needed; exclude credentials
and application inventories. Process health does not prove end-to-end behavior.

For details: [Buzz](buzz-agents.md), [maintenance](maintenance-recovery.md),
[registry](apphost-registry.md), [WebShell](webshell-tailscale.md),
[hosting](serve-skill.md), [Codex](codex-local-workflow.md), and
[GitHub](github-workflow.md).
