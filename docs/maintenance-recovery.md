# Maintenance and recovery

Reviewed 2026-09-07 against the helper source, sudoers, deployed skill, and
Gardiner’s observations. These are operation contracts, not commands to run
during a docs review.

## Authority

Gardiner uses only `sudo /usr/local/sbin/gardiner-maintenance OPERATION`:

| Operation | Effect |
| --- | --- |
| `status` | Show upgrade-worker status |
| `security-upgrade` | Detached security updates |
| `system-upgrade` | Detached upgrade with no removals; preserve existing config |
| `adapter-upgrade` | Detached Codex CLI and Codex ACP update |
| `buzz-upgrade` | Detached official Buzz artifact/image update |
| `restart-cinco` | Restart Cinco only |
| `restart-agents` | Restart Honey/Hibar/Cinco/Brain; request Gardiner with `--no-block` |
| `restart-buzz` | Restart both relays, then agents |
| `sandbox-check` | Fixed host-context Bubblewrap probe |
| `reboot` | Request reboot only when the OS marker exists |

Internal `run-*` branches do not grant extra sudo access. The four upgrade
requests launch `gardiner-maintenance@.service` workers outside the agent cgroup.
Acceptance is not completion: inspect `status`, systemd, and journals. Package
workers repair interrupted package state first. Installation and activation are
separate steps. Verify both Codex CLI and ACP versions before an agent restart.
Restart only after important work is clear. Preserve the native-root harness
exception during release updates.

## Recovery

Before a maintenance restart, save `$HOME/.gardiner-maintenance-handoff` in
Gardiner’s isolated home with mode 0600. Include operation, channel UUID, thread
root, start time, work state, and expected checks. Read it on startup/heartbeat
before new maintenance. Remove it only after verification and a successful
report to the recorded thread; keep it if verification or sending fails.

Check the failed layer: network/listener, TLS proxy, Compose health,
authenticated relay connection, then agent response. Use the helper’s
`sandbox-check`; a nested raw sandbox probe is not a host-health test.

Gardiner’s journal-group membership and plain `journalctl` access were verified.
Use bounded reads without arbitrary sudo. Missing access or empty restricted
output does not establish health. Reboot is preauthorized only when required by
completed routine maintenance; announce it and save the handoff first. The
helper also requires `/run/reboot-required`.

Recovery checks cover package integrity (`dpkg --audit`, `apt-get check`),
affected service/application health, agent reconnection, the helper sandbox
probe, pending upgrades, and the reboot marker. These checks do not grant
Gardiner arbitrary package-manager or root access.

## Dated findings

The Astra model upgrade is verified. On September 5 the main relay and five
agents restarted; pairing appears to have stayed running from August 19.
The historical reason is unexplained. Current helper semantics do not prove
historical binary behavior; neither a pairing restart nor a current fault is
established. Later sessions do not prove the first immediate session’s behavior.

On September 7 around 00:52 UTC, package audit was clean and a kernel reboot was
pending: running `6.8.0-138-generic`, requested `6.8.0-139-generic`. The last
reported Buzz worker completion was September 5. Daily policy is not execution
evidence. This docs work did not restart or upgrade anything.

## State to preserve

Back up Buzz identity configuration and PostgreSQL/MinIO/git data consistently.
Registry recovery needs SQLite, unit definitions, and served directories.
Temporal recovery needs its named volume and worker configuration. Do not
recreate volumes, rotate identities, or rerun bootstrap as routine recovery.
No automated backup or tested restore is established by this audit. Keep raw
handoffs, configs, credentials, and transcripts out of this repo.
