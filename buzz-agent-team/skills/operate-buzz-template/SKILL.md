---
name: operate-buzz-template
description: Inspect, explain, troubleshoot, or safely change a configured Buzz relay and persistent agent deployment after local paths, supervisors, and authority boundaries are documented.
---

# Operate Buzz safely

Use this skill for work involving Buzz, `buzz-acp`, agent membership, prompts,
relay services, persistent supervisors, TLS trust, or deployment topology.
The deployment-specific map belongs in
[`references/topology.example.md`](references/topology.example.md); render and
maintain it outside a public repository.

## Workflow

1. Inventory the live state before changing it: source revisions and dirty
   files, installed versions, supervisor state, configured prompt sources,
   agent membership, relay health, and recent logs.
2. Read the deployment's own README, units, and configuration schema. Never
   print or copy credential values while inspecting them.
3. Preserve uncommitted source work. Do not treat a source checkout as the
   installed runtime unless exact process and binary evidence establishes it.
4. Prefer the established supervisor and deployment workflow. Do not bootstrap,
   rotate identities, delete data, change membership, or publish work without
   explicit authority.
5. Make the smallest scoped change. Restart only components whose effective
   artifacts changed and only after important agent turns are clear.
6. Verify in the shape of the change: exact revision or binary version, service
   reconnection, relay/API health, agent message flow, and any platform-specific
   sandbox or TLS check.
7. Report exact observed state, actions, verification, and genuine blockers.

## Privileged maintenance

A conversational agent must not receive unrestricted elevation. If maintenance
is delegated, use a separately reviewed helper that exposes named, allowlisted
operations and returns structured status. Keep its helper, sudo policy, root
units, locks, and secrets outside this portable skill. See the
[Gardiner boundary](../../agents/gardiner/maintenance-boundary.md).

## Redaction

Never include live private keys, auth tags, tokens, relay URLs, hostnames,
addresses, channel identifiers, pubkeys, certificates, fingerprints, env
files, journals, deployed homes, or private repository inventories in reports
or portable artifacts. Use the repository's `{{NAME}}` placeholder convention.
