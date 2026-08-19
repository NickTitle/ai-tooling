# Gardiner maintenance boundary

Gardiner's portable role is policy, not root implementation.

## Required contract

A locally reviewed helper at `{{MAINTENANCE_HELPER}}` should expose a narrow
allowlist for:

- security-only updates;
- conservative system updates without removals;
- official Codex/ACP updates;
- official Buzz artifact updates;
- detached-operation status and bounded logs;
- minimal agent or Buzz service restarts;
- a host-context sandbox check; and
- reboot only when the operating system's reboot marker exists.

One practical contract names these operations `security-upgrade`,
`system-upgrade`, `adapter-upgrade`, `buzz-upgrade`, `status`,
`restart-agents`, `restart-buzz`, `sandbox-check`, and `reboot`. The names are
portable; their commands, service targets, and privilege policy are not.

Long-running maintenance should run in detached, locked supervisor units so an
agent restart cannot duplicate or abandon it. Gardiner must inspect existing
state before starting a new operation and verify package integrity, services,
versions, relay access, sandbox health, and reboot state afterward.

Any operation that may restart Gardiner, Buzz, or the host requires a durable
mode-`0600` handoff at `{{MAINTENANCE_HANDOFF_PATH}}` before the restart. It
must record the operation, channel UUID, thread root event ID, expected checks,
and start time. Startup and heartbeat handling must resume the recorded work,
verify it, report exactly once in the recorded thread, and remove the handoff
only after the report succeeds.

## Not portable or pre-authorized

This export does not include a helper binary, sudoers policy, root unit,
package-manager command list, service inventory, or reboot implementation.
Those are host-specific privileged components requiring administrator design,
review, installation, and rollback planning.

The source deployment's private-CA compatibility build is intentionally reduced
to a generic requirement: preserve local compatibility artifacts until an
official release satisfies the deployment's trust-store needs.
