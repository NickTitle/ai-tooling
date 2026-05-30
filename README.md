# ai-tooling

Markdown notes for the AI-assisted tooling and local hosting conventions on
`claudebox`.

Last updated: 2026-05-30

## Start Here

| Document | Purpose |
| --- | --- |
| [Box Utilities](docs/box-utilities.md) | Imported gist with the machine map, WebShell, Tailscale, apphost registry, Temporal, and debugging commands. |
| [Serve Skill](docs/serve-skill.md) | Operational notes for the Codex `serve` skill and the systemd/apphost/Temporal policy. |
| [Apphost Registry](docs/apphost-registry.md) | Registry runtime model, API use, static app registration, and external service rows. |
| [WebShell And Tailscale](docs/webshell-tailscale.md) | Browser terminal architecture, Tailscale access, bind-address conventions, and checks. |
| [Codex Local Workflow](docs/codex-local-workflow.md) | How Codex should work on this box: edits, verification, services, and safety rules. |
| [GitHub Workflow](docs/github-workflow.md) | `gh`, gists, repo publishing, and the import source for this repo. |

## Source Gist

This repo started from the secret gist:

```text
https://gist.github.com/OWNER/GIST_ID
```

The imported copy lives at [docs/box-utilities.md](docs/box-utilities.md).

## Core Rules

- Do not commit credentials, auth tokens, private keys, or personal data.
- Treat machine-specific topology as public once it lands in this repo.
- Use systemd for anything that should remain running after the agent turn.
- Use the apphost registry as the inventory/front door for discoverable local web apps.
- Use Tailscale addresses for private access from your own devices.
- Use local Temporal for delayed, scheduled, retried, or workflow-like app behavior.
- Prefer `/home/nick/Development` for project checkouts and local tools.

## Maintenance

```bash
git status
git pull --ff-only
git add README.md docs
git commit -m "Update ai tooling notes"
git push
```

Keep sensitive operational details in a private location unless they are safe to
publish.
