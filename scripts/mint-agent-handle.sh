#!/usr/bin/env bash
# SessionStart hook: give the session a cc-<adj>-<noun>-<nn> handle and add it to context.
# Word lists match elecnix/pi-agent-identity (40 x 40 x 100).
# One handle per session_id, so resume and compact keep the same one.
set -u

dir="${CLAUDE_AGENT_IDENTITY_DIR:-$HOME/.claude/handles}"
mkdir -p "$dir"

input=$(cat)
sid=$(jq -r '.session_id // empty' <<<"$input" 2>/dev/null)
source=$(jq -r '.source // "startup"' <<<"$input" 2>/dev/null)
[ -n "$sid" ] || exit 0

# A second copy of this hook (user and project settings both list it) exits silent.
mkdir "$dir/$sid.$source.announced" 2>/dev/null || exit 0

file="$dir/$sid"
if [ ! -s "$file" ]; then
  adj=(swift brave crimson gentle mighty silent lunar solar rapid steady bright shadow frost ember crystal ancient vivid cosmic rusty golden silver azure amber jade violet scarlet copper iron polar tidal storm zenith hollow lucid feral noble quiet bold keen sage)
  noun=(koala shark eagle panda dragon falcon otter wolf raven bear tiger lynx fox hawk orca crane viper badger heron lemur gecko ibis cobra sloth bison zebra civet tapir quail wren newt tahr okapi serval grouse condor marlin gar skua tern)
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    handle=$(printf 'cc-%s-%s-%02d' "${adj[RANDOM % ${#adj[@]}]}" "${noun[RANDOM % ${#noun[@]}]}" $((RANDOM % 100)))
    grep -qsxF "$handle" "$dir"/* || break
  done
  printf '%s\n' "$handle" >"$file"
fi
handle=$(cat "$file")

jq -n --arg h "$handle" '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: ("Your agent handle is " + $h + ".")}}'
