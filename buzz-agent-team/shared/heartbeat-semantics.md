# Heartbeat semantics

`buzz-acp` implements process-relative heartbeats:

- `BUZZ_ACP_HEARTBEAT_INTERVAL=0` disables heartbeats.
- Enabled intervals must be at least 10 seconds and are capped at 24 hours.
- The first tick occurs one interval after the harness process starts.
- Restarting the process resets the cadence.
- Real queued events have higher priority.
- A tick is skipped, not queued, when all agents are busy.
- At most one heartbeat is in flight globally for the harness pool.
- A custom prompt may be supplied inline or by file; those options conflict.

This is not a durable wall-clock calendar. A prompt can reduce duplicate work by
checking recent activity, but exact-once calendar execution requires a separate
durable scheduler and is outside this example.

On macOS, Buzz Desktop or `launchd` keeps `buzz-acp` alive. Do not use
`StartInterval` to send a second scheduled prompt: that would duplicate the
harness timer. The supplied plist uses `RunAtLoad` and `KeepAlive` only.

Recommended role defaults from the source deployment:

| Agent | Interval | Purpose |
| --- | ---: | --- |
| Honey | Disabled | Owner-triggered general work |
| Brain | Disabled | Bounded consultation and delegation |
| Hibar | 600 seconds | Quiet alignment audit |
| Cinco | 86,400 seconds | Daily coordination |
| Gardiner | 21,600 seconds | Maintenance inspection, with daily Buzz release policy |

Use `{{HEARTBEAT_INTERVAL_SECONDS}}` in deployment templates so each operator
can choose a supported cadence.
