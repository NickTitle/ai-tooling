# Observed versions

These values document the originating deployment on 2026-08-18. They are not
portable requirements and should be rechecked on every target host.

| Component | Observed version or revision |
| --- | --- |
| Buzz source | `8342dfcc5890b81a269a8ec3db73a8a56f76ce79` with uncommitted local changes |
| Buzz CLI/runtime release | `0.5.14` |
| Buzz relay | `0.2.1` |
| `codex-acp` | `1.3.0` |
| Codex CLI | `0.147.0` |
| GitHub plugin | `github@openai-curated`, observed cache release `0.1.8` |

Use `buzz --version`, the package manager, the supervisor's resolved executable,
and exact source revision checks to establish a target deployment's effective
versions. Do not infer the installed runtime from a nearby checkout.
