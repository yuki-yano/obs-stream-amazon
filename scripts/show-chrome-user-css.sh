#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cat "$repo_root/templates/chrome-hide-address.css"
