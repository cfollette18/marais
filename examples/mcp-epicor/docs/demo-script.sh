#!/usr/bin/env bash
# Demo script recorded by asciinema for the mcp-epicor README.
set -uo pipefail
cd /home/cfollette18/mcp-epicor

echo "epicor_mcp 0.1.0 -- read-only FastMCP server for Epicor Kinetic"
echo "============================================================"
echo
echo "Tools:  get_sales_order  get_customer  get_part  get_shipments"
echo "Guard:  client rejects non-GET ; HTTP transport fail-closes without JWT"
sleep 2

echo
echo "$ pytest tests/ -v"
echo
sleep 1
.venv/bin/python -m pytest tests/ -v
sleep 3
