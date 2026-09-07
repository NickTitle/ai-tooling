#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=$(CDPATH= cd -- "$script_dir/.." && pwd)
fail=0

scan_forbidden() {
  label=$1
  pattern=$2
  shift 2
  if rg -n --hidden --glob '!**/scripts/check-public-safe.sh' "$@" -- "$pattern" "$root"; then
    echo "public-safe check failed: $label" >&2
    fail=1
  fi
}

scan_forbidden 'Nostr private key' 'nsec1[023456789acdefghjklmnpqrstuvwxyz]+'
scan_forbidden 'PEM material' '-----BEGIN [A-Z0-9 ]*(PRIVATE KEY|CERTIFICATE)-----'
scan_forbidden 'live WebSocket URL' 'wss?://[A-Za-z0-9]'
scan_forbidden 'private IPv4 address' '(^|[^0-9])(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3})([^0-9]|$)'
scan_forbidden 'live home or deployed-state path' '/(home|Users)/[A-Za-z0-9._-]+|/var/lib/[A-Za-z0-9._-]+'
scan_forbidden 'UUID outside provenance' '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}' --glob '!**/provenance/**'
scan_forbidden '64-hex identity outside provenance' '(^|[^0-9a-f])[0-9a-f]{64}([^0-9a-f]|$)' --glob '!**/provenance/**'
scan_forbidden 'malformed placeholder' '\{\{[^}]*[^A-Z0-9_}][^}]*\}\}'

if rg -n 'StartInterval' "$root/setup/macos/com.example.buzz-agent.plist.example"; then
  echo 'public-safe check failed: launchd plist must not use StartInterval' >&2
  fail=1
fi

for key in RunAtLoad KeepAlive; do
  if ! rg -q "<key>$key</key>" "$root/setup/macos/com.example.buzz-agent.plist.example"; then
    echo "public-safe check failed: plist lacks $key" >&2
    fail=1
  fi
done

placeholders=$(rg -o --no-filename '\{\{[A-Z][A-Z0-9_]*\}\}' "$root" \
  --glob '!**/scripts/check-public-safe.sh' | sort -u)
for placeholder in $placeholders; do
  if ! grep -Fq "$placeholder" "$root/PLACEHOLDERS.md"; then
    echo "public-safe check failed: undocumented placeholder $placeholder" >&2
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo 'public-safe check passed'
