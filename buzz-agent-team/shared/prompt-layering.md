# Prompt layering

Each agent turn combines distinct layers with different ownership:

1. **Buzz base prompt** - shared platform behavior for sessions, CLI use,
   mentions, threading, workspace conventions, and safety.
2. **Persona/system prompt** - durable role, authority, and collaboration policy.
3. **Agent memory** - small cross-session facts maintained by the agent runtime.
4. **Turn context** - channel, thread root, triggering event, and reply target.
5. **User or heartbeat prompt** - the immediate request or scheduled trigger.

Do not put credentials or deployment identities into a prompt layer. Runtime
configuration supplies relay authentication, author gates, paths, and session
settings externally.

Persona prompts should remain stable. Heartbeat prompts should be short and
operational: inspect current state, perform only established work, and report a
result or genuine blocker. The persistent harness, not the text prompt, creates
the schedule.

For older ACP protocol paths the harness may prepend base/system layers to the
turn text; newer paths can deliver them through the system role. This is an
implementation detail. Templates should not depend on seeing literal `[Base]`
or `[System]` markers.
