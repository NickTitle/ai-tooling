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

Long-running maintenance should run in detached, locked supervisor units so an
agent restart cannot duplicate or abandon it. Gardiner must inspect existing
state before starting a new operation and verify package integrity, services,
versions, relay access, sandbox health, and reboot state afterward.

## Not portable or pre-authorized

This export does not include a helper binary, sudoers policy, root unit,
package-manager command list, service inventory, or reboot implementation.
Those are host-specific privileged components requiring administrator design,
review, installation, and rollback planning.

The source deployment's private-CA compatibility build is intentionally reduced
to a generic requirement: preserve local compatibility artifacts until an
official release satisfies the deployment's trust-store needs.
