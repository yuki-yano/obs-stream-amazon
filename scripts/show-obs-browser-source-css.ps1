$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$target = Join-Path $repoRoot "templates/obs-browser-source-custom.css"

Get-Content -Raw -Path $target
