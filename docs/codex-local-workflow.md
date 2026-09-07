# Codex workflow

Reviewed 2026-09-07. Read `/home/nick/AGENTS.md`, repo instructions, and the
applicable skill before changing anything.

## Configuration and skills

Ordinary agents share `/home/nick/.codex/config.toml`; Gardiner has an isolated
Codex home. Shared model/effort are Astra/medium; Brain selects xhigh. Do not
publish complete configs. Effective permissions also depend on the launching
runtime and session policy, not just config keys.

| Machine skill | Purpose |
| --- | --- |
| `operate-buzz` | Fleet, deployment, and maintenance boundaries |
| `manage-nick-github` | Account/target selection and reviewed publication |
| `serve` | systemd, registry, and Temporal |

System skill directories include imagegen, openai-docs, plugin-creator,
review-agent, skill-creator, and skill-installer. Disk presence does not guarantee
session availability. Use the session catalog for plugin skills and versions.
Use OpenAI Docs for current product guidance; this repo records local tooling.

## Editing

```bash
git status --short --branch
git worktree list
git remote -v
rg --files
```

Reuse the right worktree and keep edits off the default branch. Preserve
unrelated changes. Read code before editing. Validate docs with link, example,
whitespace, and publication-content checks; validate code with the relevant
package’s full suite. Record the exact commit tested.

```bash
git config --local user.name
git config --local user.email
git diff --check
```

Resolve missing commit identity before committing. Follow the
[GitHub workflow](github-workflow.md) for review and push.

## Execution

Owner authorization and runtime execution approval are separate. Reuse existing
authorization within scope. If execution is rejected, report the exact action
and reason, preserve work, and do not bypass the control. A quota failure does
not mean the action itself was unsafe.

Short-lived commands may run in the active shell. Persistent services belong in
systemd. General machine guidance prefers user units where suitable; the
established tooling here uses system units. Preserve its ownership and ports.
See [hosting](serve-skill.md).
