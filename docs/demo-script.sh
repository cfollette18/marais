#!/usr/bin/env bash
# Marais live demo — the local instance presenting itself. Recorded with asciinema.
set -u
cd "$(dirname "$0")/.."

printf '$ hermes -p marais mcp list\n'
hermes -p marais mcp list
sleep 2

printf '\n$ hermes -p marais chat -q "...one-liner for a bonsai CLI..." -Q\n'
hermes -p marais chat -q "In one sentence, write a recruiter-grade one-liner (max 120 chars) for a CLI that automates bonsai watering schedules. Reply with only the one-liner." -Q --reasoning none
sleep 2

printf '\n$ python3 tools/check_readme.py README.md\n'
python3 tools/check_readme.py README.md
sleep 3
