# AI tooling

Tooling and operating notes for this host. Reviewed 2026-09-07.

## Quickstart: use the existing system

This host runs Buzz, a shared workspace where people ask persistent AI agents
for help. Agents can work on files and tools, review changes, and report results
in the conversation. This guide is for an existing, configured system; it is
not an installation guide.

1. Connect your device to the authorized **Tailscale VPN**. Use the Buzz Desktop
   connection already configured for this host. If you are new, have the owner
   provide access and pairing details privately; do not paste keys into chat.
2. Open a Buzz channel and mention @Cinco. Nick tasks Cinco directly; Cinco
   scopes the request and delegates to the appropriate agent. State the outcome,
   constraints, and whether you want advice or changes made.
3. Keep follow-ups in the same thread. Agents post results, blockers, and links
   there. Open the linked file or pull request to inspect the work; a proposed
   change is not necessarily deployed or merged. Ask for status in that thread
   if you need an update.

Fictional request:

> @Cinco arrange a one-page quick reference for an imaginary tool called
> Example. Use plain English and save it for review. Do not publish or deploy it.

| Agent | Responsibility |
| --- | --- |
| Honey | General help and hands-on work |
| Cinco | Coordination and follow-through across agents |
| Brain | Difficult technical questions and architecture advice |
| Hibar | Independent review and authorized publication |
| Gardiner | Scoped host maintenance and recovery |

Each channel has its own conversation and task state. Give enough context when
moving a request to another channel. See [Buzz](docs/buzz-agents.md) for agent
sessions and messaging.

For running tools, **systemd** keeps services alive, **apphost** lists hosted
apps, and **Temporal** handles durable scheduled work. Ask for hosting explicitly
when you need it; [the hosting guide](docs/serve-skill.md) explains the choices.
[WebShell](docs/webshell-tailscale.md) provides a browser terminal over the VPN
when shell access is needed. [Maintenance](docs/maintenance-recovery.md) explains
Gardiner’s limits and recovery checks. Normal Buzz use does not require a shell
or restarting services.

Read **[How it works](docs/how-it-works.md)** for the request lifecycle,
permission layers, hosting choices, and recovery after a restart.

## Reference guides

| Guide | Covers |
| --- | --- |
| [How it works](docs/how-it-works.md) | Coordination, permissions, hosting, and restart recovery |
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
