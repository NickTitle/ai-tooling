# GitHub Workflow

The GitHub CLI is installed and authenticated as `NickTitle`.

Check auth:

```bash
gh auth status
```

This machine has the scopes needed for repositories and gists.

## Publishing

This repo is public. Do not commit credentials, auth tokens, private keys,
personal data, or anything that should not be indexed or copied elsewhere.

Create a public repo:

```bash
gh repo create NickTitle/ai-tooling --public --source=. --remote=origin --push
```

Change an existing repo to public:

```bash
gh repo edit NickTitle/ai-tooling --visibility public
```

## Gists

The imported box utilities note started as a gist:

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
