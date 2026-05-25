$ErrorActionPreference = "Stop"

$cfg = Join-Path (Get-Location) "opencode.json"

$fallbackModels = @(
    "opencode-go/deepseek-v4-flash",
    "opencode-go/deepseek-v4-pro",
    "opencode-go/glm-5",
    "opencode-go/glm-5.1",
    "opencode-go/kimi-k2.5",
    "opencode-go/kimi-k2.6",
    "opencode-go/mimo-v2.5",
    "opencode-go/mimo-v2.5-pro",
    "opencode-go/minimax-m2.5",
    "opencode-go/minimax-m2.7",
    "opencode-go/qwen3.5-plus",
    "opencode-go/qwen3.6-plus"
)

Write-Host ""
Write-Host "Fetching OpenCode models..."

try {

    $raw = opencode models --refresh 2>$null

    $models = [regex]::Matches(
        ($raw | Out-String),
        'opencode-go/[A-Za-z0-9._-]+'
    ) | ForEach-Object {
        $_.Value
    } | Sort-Object -Unique

}
catch {

    $models = @()
}

if (-not $models -or $models.Count -eq 0) {

    Write-Host ""
    Write-Host "Cannot fetch models automatically."
    Write-Host "Using fallback list."
    Write-Host ""

    $models = $fallbackModels
}

Write-Host ""
Write-Host "Available models"
Write-Host "--------------------------------"

for ($i = 0; $i -lt $models.Count; $i++) {

    Write-Host "$($i + 1). $($models[$i])"
}

function PickModel {

    param([string]$Title)

    while ($true) {

        Write-Host ""

        $pick = Read-Host $Title

        if ($pick -match '^\d+$') {

            $idx = [int]$pick - 1

            if ($idx -ge 0 -and $idx -lt $models.Count) {

                return $models[$idx]
            }
        }

        Write-Host "Invalid choice."
    }
}

$mainModel = PickModel "Choose MAIN model number"
$smallModel = PickModel "Choose SMALL model number"

Write-Host ""
Write-Host "Permission mode:"
Write-Host "1. YOLO allow everything"
Write-Host "2. Ask before dangerous actions"

while ($true) {

    $perm = Read-Host "Choose number"

    if ($perm -eq "1") {

        $permissionJson = @'
"permission": {
  "*": "allow"
}
'@

        break
    }

    if ($perm -eq "2") {

        $permissionJson = @'
"permission": {
  "*": "allow",
  "bash": "ask",
  "edit": "ask"
}
'@

        break
    }

    Write-Host "Invalid choice."
}

if (Test-Path $cfg) {

    $backup = "opencode.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss').json"

    Copy-Item $cfg $backup

    Write-Host ""
    Write-Host "Backup saved -> $backup"
}

$json = @"
{
  "`$schema": "https://opencode.ai/config.json",

  "model": "$mainModel",

  "small_model": "$smallModel",

  $permissionJson
}
"@

Set-Content -Path $cfg -Value $json -Encoding UTF8

Write-Host ""
Write-Host "Done."
Write-Host ""
Write-Host "Main model:"
Write-Host "  $mainModel"
Write-Host ""
Write-Host "Small model:"
Write-Host "  $smallModel"
Write-Host ""
Write-Host "Generated config:"
Write-Host "--------------------------------"

Get-Content $cfg

Write-Host ""
Write-Host "Start OpenCode now? (Y/N)"

$run = Read-Host

if ($run -match '^[Yy]') {

    opencode
}
