$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$target = Join-Path $repoRoot "templates/chrome-hide-address.css"

Get-Content -Raw -Path $target
