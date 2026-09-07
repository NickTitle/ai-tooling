# How it works

This guide explains the existing system, reviewed 2026-09-07. It is not an
installation recipe. The linked repository guides provide the operational
references without requiring access to private host configuration.

## From a request to a result

Nick tasks **Cinco** directly. Cinco turns the requested outcome into bounded
work and coordinates follow-through. **Honey** implements it; **Brain** advises
on difficult technical questions or takes a bounded implementation assignment.
**Hibar** independently checks the result and gates authorized publication.
**Gardiner** maintains the host within its maintenance scope.

This is the human operating convention. It keeps one coordinator responsible
for scope and progress; it does not mean the software makes other agents
incapable of responding to Nick. The inbound response policy is a separate
technical control. The [agent reference](buzz-agents.md) describes the roles
and services; the [publication workflow](github-workflow.md) explains review.

A Buzz message is a signed Nostr event. The relay delivers it to the agent's
persistent `buzz-acp` harness. An eligible mention passes the response policy
and is routed through the ACP adapter to a session for that channel. A mention
is a request for attention, not permission to perform every possible action.

Sessions of the **same agent** share core memory and files on disk, while each
channel has separate conversation and in-progress task context. A session in
another channel does not automatically know the current plan. Persistent notes
and channel history let it recover facts; they do not turn separate sessions
into one continuous reasoning process.

Results reach people only when the agent explicitly publishes a Buzz message.
Tool output and local files alone do not appear as a channel reply. The agent
uses the supplied reply destination and mentions the delegator when reporting
a result or blocker so the coordinator receives it. See
[messaging and session details](buzz-agents.md#messaging).

## Permission is several separate checks

| Layer | What it decides |
| --- | --- |
| Owner authorization | Whether the requested action belongs to the approved scope. Standing authorization covers only its stated work and limits. |
| Agent response policy | Whether an incoming author's event may trigger the agent. Configured allowlists and owner handling are distinct from the human coordination convention. |
| Runtime sandbox and approval | Whether this session may execute a command, access a path, or use the network. An authorized task can still encounter a runtime denial. |
| OS account and file permissions | What the service process can actually read, write, or execute. Sharing a workspace does not grant access to every file. |
| Gardiner's sudo helper | Which fixed privileged maintenance operations the dedicated maintenance account may request. It provides no arbitrary root shell. |

An allowed sender does not acquire unrestricted machine authority. Likewise,
standing owner authorization does not disable sandbox enforcement or widen
sudo access. Preserve work and report an actual rejection rather than bypassing
it. Gardiner's ordinary journal access and its privileged helper are different
capabilities. See [runtime controls](codex-local-workflow.md#execution) and the
[helper operation contracts](maintenance-recovery.md#authority).

## Keeping software available

The `serve` skill assigns three responsibilities:

- **systemd runs processes.** It defines service ownership, startup dependencies,
  and restart behavior. Persistent software must not depend on an agent turn or
  an open shell. Boot enablement and recovery still need verification.
- **The app registry makes web tools discoverable.** For a static directory, its
  API creates and manages a static-server unit. A custom server, container,
  database, or worker gets its own systemd unit; an external registry row can
  link to its web UI. Posting an existing server to the static endpoint would
  try to create a competing listener.
- **Temporal handles work across time.** Scheduled, delayed, or retried
  application work belongs in workflows, with workers hosted by systemd.
  Durable workflow state does not eliminate the need for a healthy worker.

Humans connect through the authorized tailnet and open the configured registry
or app URL. Internal APIs use loopback; tailnet-facing UIs need an intentional
bind and access controls. A registry listing is discovery, not an authorization
boundary or proof that every dependency works. Proxy routes also affect API
reachability. See [hosting](serve-skill.md) and [registry behavior](apphost-registry.md).

Agent heartbeats periodically give an agent a chance to inspect unfinished work.
They use separate sessions and idle scheduling; queued work takes priority and
busy pools can skip ticks. They are not precise durable application schedules.
Use Temporal for those schedules and inspect workflow progress as well as
server health. See [heartbeat behavior](buzz-agents.md) and
[Temporal](serve-skill.md#temporal).

## How Gardiner recovers after a restart

Before maintenance can restart Gardiner, Buzz, or the host, Gardiner writes a
durable handoff file in its isolated home with mode `0600` (owner read/write).
It records the operation, start time, channel, thread root, current work state,
and required verification checks. This is an instructed recovery protocol;
the helper does not enforce the handoff's presence.

Upgrade requests start separate `gardiner-maintenance@.service` workers outside
the agent's process group. They can continue if Gardiner's agent service
restarts. A command returning successfully means systemd accepted the job;
Gardiner must inspect its eventual result. A host reboot stops running workers:
their detachment is not a promise to resume execution across a reboot.

On its first turn after startup and every heartbeat, Gardiner is instructed to
read the handoff before starting new maintenance. It inspects existing workers
and recorded state, then completes the missing verification. Checks include
package integrity, affected service health, agent reconnection, pending upgrades
and reboot state, and the helper's host-context sandbox probe. Adapter updates
also require checking both CLI and ACP versions before restarting agents.

Only after verification **and successful delivery of the report to the recorded
thread** does Gardiner delete the handoff. If verification or sending fails, it
keeps the note for a later turn. Recovery should check prior reports to avoid
duplicates; sending and deleting are separate actions, not an atomic transaction.

Files on persistent storage survive ordinary service/host restarts. Enabled
services can start again under systemd. The interrupted reasoning turn and
in-memory process state need not survive, and recovery requires the host,
relay, and agent runtime to become available. A handoff is not a backup or a
guarantee against disk loss. See the [recovery contract](maintenance-recovery.md#recovery)
and [state to preserve](maintenance-recovery.md#state-to-preserve).

## A fictional request and restart timeline

1. Nick asks: “@Cinco arrange a static quick-reference page for an imaginary
   tool called Example. Review it and host it on the tailnet; do not publish
   its source externally.” Cinco scopes the page and delegates it to Honey.
2. Honey builds it in an isolated worktree and reports the exact revision.
   Hibar reviews that revision. The authorized hosting step uses the registry's
   static path and verifies the service and page before reporting its URL.
3. Later, routine maintenance needs a restart. Gardiner checks important
   in-flight work, saves the handoff, and starts the scoped detached worker.
   If the agent restarts, the worker can finish independently. If completed
   upgrades require a host reboot, Gardiner announces it and uses the guarded
   reboot operation only with the OS reboot marker present.
4. After startup, Gardiner reads the handoff, checks the worker outcome and
   system health, then posts in the saved thread. Only successful verification
   and report delivery allow handoff deletion. This is recovered work based on
   durable evidence, not continuation of the interrupted thought process.

For status, start with the **original Buzz thread**: it holds results, blockers,
review decisions, and links. Use the **app registry** to find hosted UIs and the
**Temporal UI** to inspect workflow progress. Operators use **systemd status,
bounded journals, and Gardiner's helper status** to investigate maintenance.
A service being active alone does not prove the app works. The
[read-only command reference](box-utilities.md) and
[maintenance guide](maintenance-recovery.md) explain the checks.
