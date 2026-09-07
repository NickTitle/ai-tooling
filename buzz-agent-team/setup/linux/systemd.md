# Linux: systemd reference

[`buzz-agent@.service.example`](buzz-agent@.service.example) is a non-installing
template derived from the source deployment. Render every placeholder and have a
local administrator review paths, dependencies, trust-store behavior, sandbox
hardening, restart policy, and credential ownership before installation.

Keep non-secret configuration and secrets in an external mode-restricted env
file based on [`agent.env.example`](agent.env.example). Never commit the
rendered file.

After installation:

1. Reload systemd.
2. Start one instance for `{{AGENT_SLUG}}`.
3. Verify unit state and bounded logs.
4. Verify authenticated relay access and channel membership.
5. Confirm persona and heartbeat prompt sources.
6. Exercise one controlled message and, when enabled, one heartbeat.

The unit keeps `buzz-acp` alive; it does not use a systemd timer for heartbeats.
