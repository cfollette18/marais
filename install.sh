#!/usr/bin/env bash
# Marais installer — sets up the `marais` Hermes profile. Idempotent.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
PROFILE_DIR="$HERMES_HOME/profiles/marais"

echo "==> Checking dependencies"
for cmd in hermes git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: '$cmd' is required but not on PATH" >&2
    exit 1
  fi
done
if ! command -v vhs >/dev/null 2>&1; then
  echo "note: vhs not found — demo-reel falls back to asciinema+agg"
  if ! command -v asciinema >/dev/null 2>&1; then
    echo "note: asciinema not found either — demo recording will need one of them installed"
  fi
fi

echo "==> Creating profile"
if [ ! -d "$PROFILE_DIR" ]; then
  if ! hermes profile create marais \
      --description "Marais — repo presentation harness: READMEs, branding, demo videos" \
      --no-skills --no-alias; then
    echo "hermes profile create failed; falling back to manual setup"
    mkdir -p "$PROFILE_DIR"
  fi
fi
if [ ! -f "$PROFILE_DIR/profile.yaml" ]; then
  printf 'description: "Marais — repo presentation harness: READMEs, branding, demo videos"\ndescription_auto: false\n' \
    > "$PROFILE_DIR/profile.yaml"
fi

echo "==> Linking rules and skills"
ln -sfn "$REPO_DIR/rules" "$PROFILE_DIR/rules"
mkdir -p "$PROFILE_DIR/skills"
# The profile ships a default skills dir; replace it with a link to ours.
if [ -d "$PROFILE_DIR/skills" ] && [ ! -L "$PROFILE_DIR/skills" ]; then
  if [ -z "$(ls -A "$PROFILE_DIR/skills")" ]; then
    rmdir "$PROFILE_DIR/skills"
  else
    echo "note: $PROFILE_DIR/skills is non-empty; linking marais skills alongside"
    mkdir -p "$PROFILE_DIR/skills/branding"
    ln -sfn "$REPO_DIR/skills/branding/readme-forge" "$PROFILE_DIR/skills/branding/readme-forge"
    ln -sfn "$REPO_DIR/skills/branding/repo-namer" "$PROFILE_DIR/skills/branding/repo-namer"
    ln -sfn "$REPO_DIR/skills/branding/demo-reel" "$PROFILE_DIR/skills/branding/demo-reel"
  fi
fi
[ -d "$PROFILE_DIR/skills" ] || ln -sfn "$REPO_DIR/skills" "$PROFILE_DIR/skills"

echo "==> Installing config"
# Copied, not symlinked: Hermes rewrites config.yaml at runtime, and the repo
# copy must stay a pristine template.
cp "$REPO_DIR/config.yaml" "$PROFILE_DIR/config.yaml"

echo "==> Linking .env"
if [ -e "$PROFILE_DIR/.env" ] && [ ! -L "$PROFILE_DIR/.env" ]; then
  # `hermes profile create` drops a placeholder .env. If it holds no real
  # values (only blanks/comments), back it up; if it holds anything, refuse.
  if grep -qE '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=[[:space:]]*([^"'"'"'[:space:]#]|"[^"]+"|'"'"'[^'"'"']+'"'"')' "$PROFILE_DIR/.env"; then
    echo "error: $PROFILE_DIR/.env exists and contains values — refusing to overwrite." >&2
    echo "       Move it aside and re-run install.sh." >&2
    exit 1
  fi
  mv "$PROFILE_DIR/.env" "$PROFILE_DIR/.env.bak"
  echo "moved placeholder .env to .env.bak"
fi
if [ ! -f "$HERMES_HOME/.env" ]; then
  echo "error: $HERMES_HOME/.env not found — the profile .env symlinks to it." >&2
  exit 1
fi
ln -sfn "$HERMES_HOME/.env" "$PROFILE_DIR/.env"

echo "==> Scope guard hook"
chmod +x "$REPO_DIR/hooks/guard_scope.sh"
# The hook command is an absolute path into this repo (single source of truth),
# wired via config.yaml. hooks_auto_accept: true in the profile config
# pre-approves it, so no interactive consent step is needed.

echo "==> Checking langfuse in the hermes venv"
HERMES_BIN="$(command -v hermes)"
# ~/.local/bin/hermes is a sh wrapper; the real venv lives in the install tree.
VENV_PY=""
for candidate in "$HERMES_HOME/hermes-agent/venv/bin/python" "$HERMES_HOME/hermes-agent/.venv/bin/python"; do
  if [ -x "$candidate" ]; then
    VENV_PY="$candidate"
    break
  fi
done
if [ -z "$VENV_PY" ]; then
  # Last resort: resolve the shebang of the hermes entry point.
  ENTRY="$(grep -m1 -a '^#!' "$HERMES_BIN" | tr -d '#!' || true)"
  [ -x "$ENTRY" ] && VENV_PY="$ENTRY"
fi
if [ -n "$VENV_PY" ]; then
  if ! "$VENV_PY" -m pip show langfuse >/dev/null 2>&1; then
    echo "installing langfuse into the hermes venv"
    "$VENV_PY" -m pip install langfuse
  else
    echo "langfuse already installed"
  fi
else
  echo "warning: could not locate the hermes python — check 'pip show langfuse' in its venv manually" >&2
fi

cat <<EOF

Marais is installed. Next steps:

  1. Verify the hook is registered and allowlisted:
       hermes -p marais hooks list
     (The profile sets hooks_auto_accept: true, so no manual approval is
      needed. If a consent prompt ever appears, approve it once at the TTY,
      or re-run with hooks_auto_accept confirmed in the profile config.)

  2. Present a repo (from inside the target repository):
       cd /path/to/target-repo
       hermes -p marais -z "Give this repo a recruiter-ready README"

EOF
