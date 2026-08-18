# Agent templates

| Agent | Persona | Heartbeat | Default role |
| --- | --- | --- | --- |
| Honey | [system](honey/system.template.md) | Disabled | Owner-facing generalist and implementer |
| Brain | [system](brain/system.template.md) | Disabled | Bounded deep technical advisor |
| Hibar | [system](hibar/system.template.md) | [heartbeat](hibar/heartbeat.template.md) | Safety, alignment, and publication review |
| Cinco | [system](cinco/system.template.md) | [heartbeat](cinco/heartbeat.template.md) | Periodic coordination |
| Gardiner | [system](gardiner/system.template.md) | [heartbeat](gardiner/heartbeat.template.md) | Scoped machine maintenance |

Persona prompts define durable authority and role boundaries. Heartbeat prompts
are short scheduled triggers. Runtime intervals and author gates belong in the
external agent configuration, not in the prompt file itself.

The source deployment used intervals of 600 seconds for Hibar, 86,400 seconds
for Cinco, and 21,600 seconds for Gardiner. Those are provenance defaults, not
portable requirements; deployment examples use placeholders.
