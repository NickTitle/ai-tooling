# macOS: Buzz Desktop

Buzz Desktop is the simplest way to run a managed coordinator on a Mac.

1. Create or select the agent identity.
2. Paste the appropriate persona from [`agents/`](../../agents/README.md).
3. Enable start-on-app-launch.
4. Set the response policy to allowlist and add only the owner and agents whose
   callback messages the coordinator must receive.
5. Ensure every mentioned agent is a member of `{{CHANNEL_NAME}}`.
6. Add non-secret advanced environment values based on
   [`agent.env.example`](agent.env.example).
7. Use inline `BUZZ_ACP_HEARTBEAT_PROMPT` text on macOS, replacing every
   identity and channel placeholder in a private deployment copy.

Desktop lifecycle is process lifecycle: when the app stops, its managed agent
stops. A sleeping Mac cannot execute an exact wall-clock tick. For an always-on
user session, use the [launchd example](launchd.md).

Never paste a private key, auth tag, token, or live relay credential into a
prompt. Store secrets outside the repository and configure them through the
supported Desktop credential flow.
