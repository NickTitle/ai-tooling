# Source provenance

Export assembled on 2026-08-18. Paths below identify the source material on
the originating machine for audit purposes; they are not deployment defaults.
All output templates use public placeholders.

| Output | Source | Source SHA-256 | Treatment |
| --- | --- | --- | --- |
| `agents/honey/system.template.md` | `buzz-host/agents/honey-system.md` | `b37242aa0d33552c07b6228717b86df17dba99fe86f304c3b6c2b8f3ec5b115f` | Parameterized persona template. |
| `agents/brain/system.template.md` | `buzz-host/agents/brain-system.md` | `8e654a6d00d483695a872bcba51fa4bea996aa643c3f0f2388bcc37389010369` | Parameterized persona template. |
| `agents/hibar/system.template.md` | `buzz-host/agents/hibar-system.md` | `99a244c46064199cb9e38785348fed7d5018fff282b94a79c654df0a13cd7361` | Parameterized persona template. |
| `agents/hibar/heartbeat.template.md` | `buzz-host/agents/hibar-heartbeat.md` | `c9089238c4a920c4e39f42061736406c1aab96e871ee827bf9b3115aba1e0b7c` | Copied portable trigger. |
| `agents/cinco/system.template.md` | `buzz-host/agents/cinco-system.md` | `5d9662b1fd829055ad31b3af5063af4c8d7a9950d3970283310458f028c76430` | Parameterized persona template. |
| `agents/cinco/heartbeat.template.md` | `buzz-host/agents/cinco-heartbeat.md` | `fc2c8cd60c91eb1185c9a4cb7a34c265160ecaca59990a82de1e2740caed49fa` | Parameterized channel and mention identities. |
| `agents/gardiner/system.template.md` | `buzz-host/agents/gardiner-system.md` | `07acec5a8fe5167921ddc9c8323ad93dcec1c3a146e2cb2ae63d6173b1b5a7dd` | Rewritten as portable persona, durable restart-handoff workflow, and privilege boundary. |
| `agents/gardiner/heartbeat.template.md` | `buzz-host/agents/gardiner-heartbeat.md` | `e67085ce1f8e74502107e88a5adaca95ea4ed81a9f20ff40b3df770faa5870a3` | Parameterized; stale weekly Buzz-release wording corrected to the current daily policy. |
| `agents/gardiner/maintenance-boundary.md` | `buzz-host/skills/gardiner-maintenance/SKILL.md` | `4bd738c0549ce8aa1dffc2e744264f6b45b7b08942f03d6d67faacab4cd27020` | Privileged implementation omitted; portable helper contract and durable restart-handoff semantics documented. |
| `shared/buzz-base-prompt.md` | `buzz/crates/buzz-acp/src/base_prompt.md` | `35260e783e6ae8d37174445bac9259792131fec166c834606e6651df48319308` | Exact effective local runtime snapshot; Apache-2.0. See note below and the bundled [license](../LICENSES/Apache-2.0.txt). |
| `LICENSES/Apache-2.0.txt` | `buzz/LICENSE` | `108cb15997e51b75a8d18b0c1e2c52bd3879d051ab02118973387df1e4aab584` | Exact upstream Buzz license copy supplied with the redistributed base prompt. |
| `setup/linux/buzz-agent@.service.example` | `buzz-host/buzz-agent@.service` | `05221f7025aba08a06a53770701ea5b750a18ea56ef038bda7e9f7482aa9e6d0` | Sanitized, non-installing systemd example. |
| `skills/operate-buzz-template/` | local `operate-buzz` skill and setup reference | `28b4aac9e9ab663c6b6af6cea7f681678fd9c64f3537daf9d46495f382d13b4c` (`SKILL.md`), `072b0b030aac11b9e4c274788770178057acf57d255881d66d0bdaf9f7ed642b` (`setup.md`) | Policy rewritten; private topology and generated inventory excluded. |

## Buzz base-prompt snapshot

The vendored base prompt is byte-for-byte the accepted effective local runtime
snapshot: 15,424 bytes and 147 lines, SHA-256
`35260e783e6ae8d37174445bac9259792131fec166c834606e6651df48319308`.
Its source state was Buzz HEAD
`8342dfcc5890b81a269a8ec3db73a8a56f76ce79` plus an explicitly recorded,
uncommitted local prompt correction. It is **not** represented as current
upstream Buzz source. Buzz source attribution and licensing remain Apache-2.0;
recipients receive the complete [upstream license text](../LICENSES/Apache-2.0.txt)
with this export.

The supporting behavior summaries were derived from the same Buzz checkout's
`crates/buzz-acp/README.md`, `src/config.rs`, `src/lib.rs`, and `src/pool.rs`.
Rust implementation files and runtime binaries were not copied.
