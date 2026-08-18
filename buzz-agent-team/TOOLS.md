# Tools and skills

## Runtime tools

| Tool | Purpose | Portability rule |
| --- | --- | --- |
| `buzz-acp` | Maintains per-channel sessions, applies prompt layers, and dispatches heartbeats. | Install from Buzz; do not vendor binaries. |
| `codex-acp` | Bridges `buzz-acp` to Codex. | Install through the supported package path. |
| `buzz` CLI | Reads and writes Buzz messages, channels, workflows, repos, issues, and PRs. | Use `buzz --help`; keep auth outside this repo. |
| Buzz Desktop | Manages local agents on macOS and other desktop platforms. | Use inline heartbeat text where file paths are inconvenient. |
| `launchd` / systemd | Keeps the harness process alive. | These supervise the process; they do not replace the harness heartbeat timer. |

## Codex customization surfaces

- Agent persona and heartbeat prompts are ordinary text templates in
  [`agents/`](agents/README.md).
- Reusable operating procedures belong in a skill with `SKILL.md` and optional
  references or scripts. See [`skills/`](skills/README.md).
- OpenAI system skills are installation-managed dependencies. Do not copy
  directories such as `.codex/skills/.system/`.
- Plugins are installable bundles. Record plugin identifiers and versions; do
  not copy plugin cache directories.
- Global Codex configuration and authentication stay outside this repository.

Useful official references:

- [OpenAI: build skills](https://learn.chatgpt.com/docs/build-skills)
- [OpenAI: skills and plugins](https://learn.chatgpt.com/docs/skills-and-plugins)

## External dependencies used by the source team

- GitHub plugin identifier: `github@openai-curated`
- A genericized GitHub review/publication skill may be added separately. Do not
  copy mutable account inventories.
- Host-specific serving and maintenance skills are intentionally not vendored;
  this export includes only their portable policy boundaries.
