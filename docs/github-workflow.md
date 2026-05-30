# GitHub Workflow

The GitHub CLI is installed and authenticated as `NickTitle`.

Check auth:

```bash
gh auth status
```

This machine has the scopes needed for private repositories and gists.

## Private By Default

Machine notes should stay private unless they are scrubbed first. This repo
contains Tailscale hostnames, private IPs, local paths, ports, and service names.

Create a private repo:

```bash
gh repo create NickTitle/ai-tooling --private --source=. --remote=origin --push
```

## Gists

The imported box utilities note started as a secret gist:

```text
https://gist.github.com/OWNER/GIST_ID
```

Useful commands:

```bash
gh gist list --limit 10
gh gist view GIST_ID --files
gh gist view GIST_ID --raw
```

This `gh` install creates secret gists by default. Use `--public` only for notes
that are safe to list publicly.

## Repo Maintenance

```bash
git status --short
git diff
git add README.md docs
git commit -m "Update ai tooling notes"
git push
```

Use short commit messages that describe the documentation change. Keep generated
or local-only files out of this Markdown repo unless they are part of the notes.
