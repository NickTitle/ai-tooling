# macOS: launchd

The example LaunchAgent keeps one persistent `buzz-acp` process alive. The
harness's own heartbeat timer remains the only scheduler.

Files:

- [`com.example.buzz-agent.plist.example`](com.example.buzz-agent.plist.example)
- [`run-agent.sh.example`](run-agent.sh.example)
- [`agent.env.example`](agent.env.example)

## Private deployment steps

1. Render placeholders into files outside the public checkout.
2. Put non-secret configuration in `{{CONFIG_FILE_PATH}}`.
3. Put credentials in `{{SECRETS_FILE_PATH}}`, owned by the user and mode 0600.
4. Install the rendered plist under `~/Library/LaunchAgents/`.
5. Validate with `plutil -lint` before loading it.
6. Bootstrap the LaunchAgent with the current user's `launchctl` domain.
7. Verify the process, logs, authenticated relay access, and one controlled
   heartbeat cycle.

The plist deliberately uses `RunAtLoad` and `KeepAlive`. It must not contain
`StartInterval`, credentials, or inline secret environment values.

Keychain integration may replace the external secret file if a locally reviewed
wrapper retrieves only the required values without logging them.
