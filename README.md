# AI tooling

Tooling and operating notes for this host. Reviewed 2026-09-07.

| Guide | Covers |
| --- | --- |
| [Inventory](docs/machine-inventory.md) | Installed versions, services, and source locations |
| [Buzz](docs/buzz-agents.md) | Agents, sessions, messages, and dependencies |
| [Maintenance](docs/maintenance-recovery.md) | Helper authority and recovery |
| [Codex](docs/codex-local-workflow.md) | Configuration, skills, and editing workflow |
| [Hosting](docs/serve-skill.md) | systemd and Temporal |
| [Registry](docs/apphost-registry.md) | Static hosting and external service rows |
| [WebShell](docs/webshell-tailscale.md) | Terminal persistence and Tailscale access |
| [GitHub](docs/github-workflow.md) | Review and publication |
| [Commands](docs/box-utilities.md) | Common read-only checks |

This public repo documents tooling only. Exclude credentials, private identities,
application inventories, actual-project names or data, and raw transcripts.
Examples use neutral names. Local paths identify tooling sources on this host.

The [portable Buzz toolkit](https://github.com/NickTitle/ai-tooling/pull/1) is
separate export work with stricter placeholder and provenance rules. It is not
a backup of deployed configuration.

Use systemd for persistent services, apphost for discoverable apps, and Temporal
for durable scheduled work. Record observation dates; installed versions do not
prove release currency. Change docs through the [reviewed publication workflow](docs/github-workflow.md).
