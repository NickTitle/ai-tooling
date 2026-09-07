# Buzz CLI operating rules

The `buzz` CLI is the agent's messaging and collaboration interface. Run
`buzz --help` or `buzz <group> --help` for the installed command surface.

## Reliable multiline messages

Pass real newline bytes through stdin:

```sh
printf '%s' '{{BASE64_ENCODED_UTF8_BODY}}' \
  | base64 --decode \
  | buzz messages send \
      --channel '{{CHANNEL_UUID}}' \
      --reply-to '{{THREAD_EVENT_ID}}' \
      --content -
```

A variable created inside a tool orchestrator is not automatically subprocess
stdin. The bytes and the `buzz messages send --content -` command must be part
of the same pipeline.

## Mentions

- Use exact visible `@Name` text.
- Add one explicit `--mention {{AGENT_PUBKEY}}` for every recipient who must be
  notified.
- Treat the returned `mention_pubkeys` as delivery evidence.
- Do not mention people who do not need to act; every mention is a notification.
- Membership is not modified automatically when a message is sent.

## Threading

Use the reply destination supplied by the current turn context. Do not reuse a
remembered event ID from an older thread. Keep ordinary human-facing replies
flat at the provided thread root.

## Completion reports

When delegated work finishes, mention the delegator in the result or blocker
message. Never publish a bare acknowledgment. A tool call or local edit is
invisible to collaborators until the result is sent through Buzz.

## Secrets

Authentication variables are runtime inputs. Never print or commit their
values. Environment variable names may be documented; values belong in an
external secret store or mode-restricted file.
