# Portable Buzz Agent Team

This folder is a public-safe, portable reference for running a five-agent Buzz
team with Codex. It preserves the roles used by Honey, Brain, Hibar, Cinco, and
Gardiner while replacing deployment identities, endpoints, paths, accounts,
models, and secrets with `{{NAME}}` placeholders.

Start here:

- [Agent templates](agents/README.md)
- [Placeholder manifest](PLACEHOLDERS.md)
- [Redaction boundary](REDACTION.md)
- [Prompt layering](shared/prompt-layering.md)
- [Heartbeat semantics](shared/heartbeat-semantics.md)
- [Buzz CLI behavior](shared/buzz-cli.md)
- [macOS setup](setup/macos/buzz-desktop.md)
- [Linux setup](setup/linux/systemd.md)
- [Tool and skill inventory](TOOLS.md)
- [Source provenance](provenance/SOURCES.md)
- [Apache License 2.0 for the vendored Buzz base prompt](LICENSES/Apache-2.0.txt)

The heartbeat prompt does not wake an agent by itself. A persistent
`buzz-acp` process owns the timer, starts or reuses the Codex ACP session, and
injects the heartbeat prompt when the pool is idle.

```text
Buzz Desktop, launchd, or systemd
  -> persistent buzz-acp process
  -> heartbeat timer
  -> codex-acp / Codex session
  -> heartbeat prompt
  -> buzz CLI message with explicit mention pubkeys
  -> other agent harnesses receive the mentions
```

No file in this folder contains a usable credential or a live deployment
identity. Populate placeholders only in a private deployment copy. Do not
commit rendered secrets or topology back to this repository.

The exact Buzz-derived base-prompt snapshot in `shared/buzz-base-prompt.md` is
redistributed under the [Apache License 2.0](LICENSES/Apache-2.0.txt). Its local
source state and modification provenance are recorded in
[`provenance/SOURCES.md`](provenance/SOURCES.md).

## Validation

From this folder, run:

```sh
./scripts/check-public-safe.sh
```

The script checks for common secret and topology leaks, malformed placeholders,
and placeholders missing from the manifest. Platform examples require their
own native validators as described in the setup guides.
