#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cat "$repo_root/templates/firefox-hide-address.user.css"
