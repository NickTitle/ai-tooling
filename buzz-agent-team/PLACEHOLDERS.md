# Placeholder manifest

All deployment substitutions use `{{UPPER_SNAKE_CASE}}`. Render them only in a
private deployment copy.

`{{NAME}}` denotes the placeholder syntax itself; it is not a deployable value.

## Identity and routing

- `{{OWNER_NAME}}`, `{{OWNER_PUBKEY}}`
- `{{AGENT_NAME}}`, `{{AGENT_SLUG}}`, `{{AGENT_PUBKEY}}`
- `{{HONEY_PUBKEY}}`, `{{BRAIN_PUBKEY}}`, `{{HIBAR_PUBKEY}}`,
  `{{CINCO_PUBKEY}}`, `{{GARDINER_PUBKEY}}`
- `{{CHANNEL_NAME}}`, `{{CHANNEL_UUID}}`
- `{{RESPOND_TO_MODE}}`, `{{RESPOND_TO_ALLOWLIST}}`

## Runtime and prompts

- `{{MODEL_ID}}`, `{{REASONING_EFFORT}}`
- `{{SYSTEM_PROMPT_PATH}}`, `{{HEARTBEAT_PROMPT_PATH}}`
- `{{HEARTBEAT_INTERVAL_SECONDS}}`, `{{SESSION_TITLE}}`
- `{{BUZZ_ACP_BIN}}`, `{{CODEX_ACP_BIN}}`, `{{BUZZ_BIN_DIR}}`,
  `{{BUZZ_ACP_BIN_DIR}}`
- `{{BUZZ_SOURCE_REVISION}}`, `{{BUZZ_VERSION}}`, `{{CODEX_ACP_VERSION}}`
- `{{THREAD_EVENT_ID}}`, `{{BASE64_ENCODED_UTF8_BODY}}`

## Filesystem and service wiring

- `{{WORKSPACE_ROOT}}`, `{{BUZZ_HOST_ROOT}}`, `{{BUZZ_CONFIG_DIR}}`,
  `{{CODEX_HOME}}`
- `{{OS_USER}}`, `{{OS_GROUP}}`, `{{MAINTENANCE_OS_USER}}`
- `{{AGENT_ENV_FILE}}`, `{{AGENT_SECRET_FILE}}`, `{{SECRETS_FILE_PATH}}`
- `{{TLS_CA_FILE}}`, `{{LOG_PATH}}`
- `{{AGENT_UNIT}}`, `{{AGENT_TEMPLATE_UNIT}}`, `{{RELAY_UNIT}}`,
  `{{PAIRING_RELAY_UNIT}}`, `{{MAINTENANCE_UNIT_TEMPLATE}}`
- `{{MAINTENANCE_HELPER}}`, `{{MAINTENANCE_SKILL}}`,
  `{{MAINTENANCE_HANDOFF_PATH}}`

## Network and deployment

- `{{RELAY_URL}}`, `{{PAIRING_RELAY_URL}}`, `{{APP_HOST}}`
- `{{RELAY_PORT}}`, `{{PAIRING_RELAY_PORT}}`, `{{APP_PORT}}`
- `{{COMPOSE_PROJECT}}`, `{{COMPOSE_FILE}}`

## macOS launchd

- `{{LAUNCHD_LABEL}}`, `{{LAUNCHD_WRAPPER_PATH}}`
- `{{CONFIG_FILE_PATH}}`, `{{STANDARD_OUT_PATH}}`, `{{STANDARD_ERROR_PATH}}`

## Accounts and publication

- `{{GITHUB_USER}}`, `{{GITHUB_ORG}}`, `{{GITHUB_REPOSITORY}}`
- `{{GITHUB_MANAGEMENT_SKILL}}`

## Secrets

- `{{BUZZ_PRIVATE_KEY}}`, `{{BUZZ_AUTH_TAG}}`, `{{BUZZ_API_TOKEN}}`

Secret placeholders may appear only in private-rendering instructions or
external secret-file examples. Never replace them in a committed file.
