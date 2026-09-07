# Private deployment topology example

Do not render this file in the public repository. Maintain the populated copy
with mode `0600` or equivalent access controls.

| Item | Value |
| --- | --- |
| Workspace | `{{WORKSPACE_ROOT}}` |
| Buzz host configuration | `{{BUZZ_HOST_ROOT}}` |
| Buzz configuration | `{{BUZZ_CONFIG_DIR}}` |
| Codex home | `{{CODEX_HOME}}` |
| Relay service | `{{RELAY_UNIT}}` |
| Pairing relay service | `{{PAIRING_RELAY_UNIT}}` |
| Agent unit | `{{AGENT_UNIT}}` |
| Main channel | `{{CHANNEL_UUID}}` |
| Maintenance helper | `{{MAINTENANCE_HELPER}}` |
| TLS trust source | `{{TLS_CA_FILE}}` |
| Source revision | `{{BUZZ_SOURCE_REVISION}}` |
| Installed Buzz version | `{{BUZZ_VERSION}}` |
| Installed Codex ACP version | `{{CODEX_ACP_VERSION}}` |

Record credential locations, not credential values. Document who may authorize
membership changes, identity rotation, publishing, service restarts, and
privileged maintenance.
