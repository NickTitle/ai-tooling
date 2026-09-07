# Public-safe redaction boundary

This policy is stricter than the parent repository's machine-topology rule and
overrides it for every file under `buzz-agent-team/`.

## Never include

- Private keys, auth tags, API tokens, passwords, session secrets, or usable
  authentication material.
- Live relay URLs, private hostnames or addresses, channel UUIDs, agent or owner
  pubkeys, certificate material, certificate fingerprints, or CA contents.
- Personal usernames, home paths, deployed Codex homes, live env files,
  journals, runtime state, locks, or Docker volume data.
- Private repository/account inventories, plugin caches, binaries, compiled
  helpers, live sudoers files, root units, Compose/bootstrap state, or backups.

## Allowed

- Environment variable names with omitted values or `{{NAME}}` placeholders.
- Generic role names: Honey, Brain, Hibar, Cinco, and Gardiner.
- Sanitized examples that cannot connect, authenticate, notify a real identity,
  or install privileged components without deliberate local rendering and
  administrator review.
- Source hashes and public upstream commit identifiers recorded in provenance.

## Review rule

Run [`scripts/check-public-safe.sh`](scripts/check-public-safe.sh), then manually
review every added line. Automated scanning supplements, but never replaces,
human review.
