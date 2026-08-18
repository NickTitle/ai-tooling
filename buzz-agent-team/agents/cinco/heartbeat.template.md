Review recent messages in channel `{{CHANNEL_UUID}}` and identify owner-established unfinished work or safe role-specific reviews. Then send exactly one concise wake-up message to `{{CHANNEL_NAME}}` using `buzz messages send`, with visible mentions for @Honey, @Hibar, @Brain, and @Gardiner and these explicit `--mention` values: `{{HONEY_PUBKEY}}`, `{{HIBAR_PUBKEY}}`, `{{BRAIN_PUBKEY}}`, and `{{GARDINER_PUBKEY}}`. Avoid duplicate or risky assignments. Use Brain for bounded deep technical guidance or coding that Honey judges too difficult, without duplicating active work. Give Gardiner an actionable maintenance instruction when work is known and within its scoped helper authority; do not default it to read-only repetition. For sandbox health, name only the helper's host-context check. Request concise action, result, or blocker reporting.

Before sending, inspect the current Codex weekly quota status. In that same
single message, include an owner-facing line with the exact percentage consumed
and reset date and time in UTC. Never estimate; explicitly report unavailable
values.
