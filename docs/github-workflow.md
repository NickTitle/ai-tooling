# GitHub workflow

Reviewed 2026-09-07. Publish tooling-only content to
[NickTitle/ai-tooling](https://github.com/NickTitle/ai-tooling). Authenticate as
NickTitle; shiptoast is an organization, not a second login.

## Inspect and review

```bash
gh auth status
gh api user --jq .login
git status --short --branch
git worktree list
git remote -v
git fetch origin
gh pr list --repo NickTitle/ai-tooling --state open
```

Read `manage-nick-github`. Confirm the target and preserve other branches and
worktrees. Owner publication direction supplies authorization; independent
review still checks the exact commit and content.

Review every included file for credentials and actual-project names, paths,
links, data, or inventories. Use neutral examples. The portable Buzz export
has stricter placeholder, license, and provenance/checksum rules.

## Publish

After editing and validating on a branch:

```bash
git diff --check
git add README.md docs
git commit -m "Update tooling documentation"
git rev-parse HEAD
# Review this exact commit before pushing.
git push -u origin HEAD
```

Create or update a draft PR. Pass a prepared text file with real newlines:

```bash
gh pr create --repo NickTitle/ai-tooling --base main --draft \
  --title "Update tooling documentation" --body-file /tmp/tooling-pr.md
```

Verify the remote branch SHA matches the reviewed commit. Report the PR link,
SHA, checks, and review state. A pushed branch is not a merge.

## Disclosure cleanup

If content was already published, audit affected branches, history, and PR
bodies/comments. Coordinate replacement ancestry before moving refs. Use
explicit force-with-lease only for owner-authorized affected refs; preserve
unrelated work. Recheck remote contents afterward. Force-push does not guarantee
removal from GitHub caches, PR history, forks, or clones. Revoke exposed real
credentials even if their text is removed.
