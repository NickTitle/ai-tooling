# Instructions for this folder

The rules in [REDACTION.md](REDACTION.md) override any looser machine-topology
policy in parent documentation.

- Keep this folder portable and public-safe.
- Use only `{{UPPER_SNAKE_CASE}}` placeholders.
- Never add live credentials, identities, endpoints, certificate material,
  private repository inventories, absolute personal paths, or deployed state.
- Preserve the five role boundaries unless an owner-directed redesign is being
  documented.
- Keep platform-specific wiring under `setup/macos/` or `setup/linux/`.
- Treat privileged maintenance examples as contracts requiring administrator
  review, not installable defaults.
- Update provenance and checksums whenever a copied or templated prompt changes.
- Run `scripts/check-public-safe.sh`, relative-link checks, shell syntax checks,
  plist validation, and `git diff --check` before review.
