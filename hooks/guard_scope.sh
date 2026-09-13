#!/usr/bin/env bash
# guard_scope.sh — Marais pre_tool_call hook.
# Blocks file writes/edits whose target path falls outside the session's
# working directory (the target repo). Reads a JSON payload on stdin:
#   {hook_event_name, tool_name, tool_input, session_id, cwd}
# Prints {"action":"block","message":"..."} to block; empty output allows.
set -euo pipefail

payload="$(cat)"

PAYLOAD="$payload" python3 - <<'PYEOF'
import json, os, sys

try:
    payload = json.loads(os.environ.get("PAYLOAD") or "")
except Exception:
    sys.exit(0)  # unparseable payload — allow rather than break the session

tool_input = payload.get("tool_input") or {}
cwd = os.path.realpath(payload.get("cwd") or os.getcwd())

paths = []
if isinstance(tool_input, dict):
    p = tool_input.get("path")
    if isinstance(p, str):
        paths.append(p)
    # V4A patch mode carries file paths inside the patch body.
    body = tool_input.get("patch")
    if isinstance(body, str):
        for line in body.splitlines():
            for marker in ("*** Add File: ", "*** Update File: ", "*** Delete File: ", "*** Move to: "):
                if line.startswith(marker):
                    paths.append(line[len(marker):].strip())

def block(msg):
    print(json.dumps({"action": "block", "message": msg}))
    sys.exit(0)

for raw in paths:
    if not raw:
        continue
    full = os.path.realpath(os.path.join(cwd, raw) if not os.path.isabs(raw) else raw)
    if full != cwd and not full.startswith(cwd + os.sep):
        block(f"Marais scope guard: '{raw}' resolves outside the target repo ({cwd}). "
              "Writes are confined to the repository being presented.")

sys.exit(0)
PYEOF
