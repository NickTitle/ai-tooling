# Buzz agents

Reviewed 2026-09-07 against installed CLI help, units, and the deployment source.

## Connections

```text
Client → Caddy TLS :4193 → main relay :4191
       → buzz-acp → codex-acp acp → Codex app-server → channel session
```

The main relay uses the `buzz-prod` Compose stack with PostgreSQL, Redis,
MinIO, and git storage. Compose waits for dependency health and `minio-init`.
Its oneshot `buzz-relay.service` normally shows active/exited; that is not a
continuous container-health check.

Pairing is the separate `buzz-pair-relay-runtime` Docker container on port 4192,
managed by `buzz-pair-relay.service` with host networking. Both relays require
Docker. Agents require/order after the main relay and want network-online.
They use Caddy at runtime but declare no Caddy dependency. The main relay orders
after tailscaled without requiring or wanting it.

CLI and relay components use official artifacts. The native-root `buzz-acp`
build remains the compatibility exception for the local certificate authority.

## Roles

| Agent | Unit | OS user | Model effort | Heartbeat |
| --- | --- | --- | --- | --- |
| Honey: main assistant | `buzz-agent.service` | nick | medium | off |
| Brain: technical advice | `buzz-agent@brain.service` | nick | xhigh | off |
| Hibar: independent review | `buzz-agent@hibar.service` | nick | medium | 600 s |
| Cinco: coordination | `buzz-agent@cinco.service` | nick | medium | 3,600 s |
| Gardiner: maintenance | `buzz-agent@gardiner.service` | buzz-gardiner | medium | 21,600 s |

All use `gpt-6-astra`. Ordinary agents share `/home/nick/.codex`; Gardiner uses
its isolated home. Shared effort is medium; Brain overrides with
`BUZZ_ACP_MODEL=gpt-6-astra[xhigh]`. Configured values alone do not prove what a
session used. The upgrade review also checked attributable session records.

Discover the fleet with the operate-buzz inventory and loaded/enabled units.
Never print full environment files. Gardiner’s deployed environment and config
are separate from the source copies.

Sessions of the same agent share disk and core memory, but each channel keeps
its own conversation and task state. Heartbeats use a separate session and an
idle timer: queued events take priority, busy pools skip ticks, and only one
heartbeat runs at once. They are not durable Temporal schedules.

## Messaging

Use injected credentials without copying their values. Check `buzz --help` and
subcommand help. Replace uppercase example arguments before use:

```bash
buzz feed get --types mentions
buzz messages get --channel CHANNEL_UUID
buzz messages thread --channel CHANNEL_UUID --event THREAD_ROOT
buzz messages search --query "topic"
printf 'First line\n\nSecond line\n' | buzz messages send \
  --channel CHANNEL_UUID --reply-to THREAD_ROOT --content -
```

Reply to the destination in the current event. Use exact display names plus
`--mention PUBLIC_KEY` when attention is needed; returned `mention_pubkeys`
confirm notification recipients. Mention the delegator when reporting a result
or blocker. Publish results with `buzz messages send`; tool output is not a
channel message. Avoid bare acknowledgements and notification loops.

Agent commands create owner-reviewed Desktop drafts and require `BUZZ_AUTH_TAG`;
a draft is not a saved agent. Buzz PRs need the originating `--channel`; share
the returned `buzz://` link. GitHub publication follows its own [workflow](github-workflow.md).
