<#
.SYNOPSIS
    NEY Coder AI — Init Project (Windows PowerShell)
.DESCRIPTION
    Sets up a new or existing project with NEY agent system.
    Creates: work.md, memory/, archive/, docs/, .opencode/
.PARAMETER Dir
    Target project directory (default: current directory)
.PARAMETER Name
    Project name (default: directory name)
.PARAMETER NoGit
    Skip git init
.PARAMETER Copy
    Copy files instead of symlink
.EXAMPLE
    .\init-project.ps1 -Dir ..\my-project -Name "My App"
.EXAMPLE
    .\init-project.ps1 -NoGit
#>

param(
    [string]$Dir = "",
    [string]$Name = "",
    [string]$Agents = "all",
    [switch]$Mini,
    [switch]$NoGit,
    [switch]$Copy
)

$ErrorActionPreference = "Stop"
$NevRepo = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoUrl = "https://github.com/KCCHDEV/coder-noey-skill"
$RawUrl = "https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"
$InRepo = Test-Path (Join-Path $NevRepo "agents" "ney" "SKILL.md")
$Variant = if ($Mini) { "mini" } else { "SKILL" }

function Write-Log    { Write-Host "[NEV] $($args[0])" -ForegroundColor Green }
function Write-Warn   { Write-Host "[WARN] $($args[0])" -ForegroundColor Yellow }
function Write-Err    { Write-Host "[ERR] $($args[0])" -ForegroundColor Red }
function Write-Info   { Write-Host "[INFO] $($args[0])" -ForegroundColor Cyan }

# ----- Determine target -----
if ([string]::IsNullOrWhiteSpace($Dir)) {
    $TargetDir = (Get-Location).Path
} else {
    $TargetDir = Resolve-Path $Dir -ErrorAction SilentlyContinue
    if (-not $TargetDir) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        $TargetDir = (Resolve-Path $Dir).Path
    }
}

if ([string]::IsNullOrWhiteSpace($Name)) {
    $ProjectName = Split-Path $TargetDir -Leaf
} else {
    $ProjectName = $Name
}

$Agents = @("yui", "ney", "fha", "masa", "eria", "mochi")

Write-Host ""
Write-Host "╭─────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│   NEY Coder AI — Init Project               │" -ForegroundColor Cyan
Write-Host "│   Project: $ProjectName" -ForegroundColor Cyan
Write-Host "│   Target:  $TargetDir" -ForegroundColor Cyan
Write-Host "╰─────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

# ----- Check if already initialized -----
if (Test-Path (Join-Path $TargetDir "work.md")) {
    Write-Warn "work.md already exists — project may already be initialized."
    $answer = Read-Host "Continue anyway? [y/N]"
    if ($answer -notmatch '^[Yy]') { Write-Log "Aborted."; exit 0 }
}

# ----- Create structure -----
Write-Log "Creating project structure..."
New-Item -ItemType Directory -Path (Join-Path $TargetDir "memory") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TargetDir "archive") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TargetDir "docs" "plans") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TargetDir "docs" "designs") -Force | Out-Null

# ----- work.md -----
$workContent = @"
# work.md — $ProjectName

> Auto-created by NEY Coder AI Init Project

## Current Status

- State: active
- Last updated: $(Get-Date -Format 'yyyy-MM-dd')
- Current task:
- Main goal:

## User Request

...

## Active Plan

- [ ] ...

## Decisions

| Date | Decision | Reason |
|---|---|---|

## Files Changed

| File | Action | Notes |
|---|---|---|

## Next Steps

- [ ] ...

## Resume Prompt

อ่าน work.md นี้แล้วทำต่อจาก:
1. ...
"@
Set-Content -Path (Join-Path $TargetDir "work.md") -Value $workContent -Encoding UTF8
Write-Log "  Created: work.md"

# ----- memory/mem.md -----
$memContent = @"
# mem.md — Long-Term Memory

> เก็บ decisions, constraints, preferences ที่ต้องจำข้าม session

## Decisions

| Date | Decision | Context | Reason |
|---|---|---|---|

## Constraints

- ...

## Preferences

- ...

## Cross-Reference

| ไฟล์ | บทบาท |
|---|---|
| `work.md` | session memory |
| `memory/mem.md` | ไฟล์นี้ |
| `archive/ARCHIVE_LOG.md` | archived code log |
"@
Set-Content -Path (Join-Path $TargetDir "memory" "mem.md") -Value $memContent -Encoding UTF8

$summaryContent = @"
# Summary — Project Overview

## Tech Stack

- ...

## Structure

├── work.md
├── memory/
├── archive/
└── docs/

## Team

- Ney (DEV) — implement
- Fha (plan) — spec
- Masa (logic) — design
- Eria (UI) — design
- Yui (orchestrate) — route
- Mochi (PM) — manage
"@
Set-Content -Path (Join-Path $TargetDir "memory" "summary.md") -Value $summaryContent -Encoding UTF8
Write-Log "  Created: memory/mem.md + memory/summary.md"

# ----- archive log -----
$archiveContent = @"
# ARCHIVE_LOG.md

> Log of all archived/replaced files

| Date | File | Reason | Restore |
|---|---|---|---|
"@
Set-Content -Path (Join-Path $TargetDir "archive" "ARCHIVE_LOG.md") -Value $archiveContent -Encoding UTF8
Write-Log "  Created: archive/ARCHIVE_LOG.md"

# ----- .opencode/skills/ -----
Write-Log "Setting up OpenCode skills..."
$skillsDir = Join-Path $TargetDir ".opencode" "skills"

if ($Agents -eq "all") {
    $agentList = @("yui", "ney", "fha", "masa", "eria", "mochi")
} else {
    $agentList = $Agents.Split(',') | ForEach-Object { $_.Trim() }
}

function Download-Skill {
    param([string]$Agent, [string]$Variant, [string]$Destination)
    New-Item -ItemType Directory -Path (Split-Path $Destination -Parent) -Force | Out-Null

    if ($InRepo) {
        $src = Join-Path $NevRepo "agents" $Agent "$Variant.md"
        if (-not (Test-Path $src)) { $src = Join-Path $NevRepo "agents" $Agent "SKILL.md" }
        if (Test-Path $src) {
            if ($Copy) {
                Copy-Item -LiteralPath $src -Destination $Destination -Force
            } else {
                # Windows: copy is safest (no native symlink for files easily)
                Copy-Item -LiteralPath $src -Destination $Destination -Force
            }
            return $true
        }
        return $false
    }

    $url = "$RawUrl/agents/$Agent/$Variant.md"
    try {
        Invoke-WebRequest -Uri $url -OutFile $Destination -UseBasicParsing -ErrorAction Stop | Out-Null
        return $true
    } catch { return $false }
}

foreach ($agent in $agentList) {
    $dst = Join-Path $skillsDir $agent "SKILL.md"
    if (Download-Skill -Agent $agent -Variant $Variant -Destination $dst) {
        Write-Log "  $Variant: $agent → .opencode/skills/$agent/"
    } else {
        Write-Warn "  Skipping $agent — source not found"
    }
}

# ----- .opencode/opencode.json -----
$cfg = Join-Path $TargetDir ".opencode" "opencode.json"
if (-not (Test-Path $cfg)) {
    $json = @'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/deepseek-v4-flash",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": {
    "*": "allow"
  }
}
'@
    Set-Content -Path $cfg -Value $json -Encoding UTF8
    Write-Log "  Created: .opencode/opencode.json"
} else {
    Write-Warn "  Config exists: .opencode/opencode.json (skipped)"
}

# ----- AGENTS.md -----
$agentsMd = Join-Path $TargetDir "AGENTS.md"
if (-not (Test-Path $agentsMd)) {
    $agentsContent = @'
You are Ney, a feminine AI DEV coding teammate.
You implement, refactor, debug, and maintain code.

Core behavior:
- Read the task carefully before editing.
- Inspect relevant files first.
- Never delete important code; archive first.
- Keep UI clean, cute, responsive.
- Validate backend input.
- Avoid secrets, hard deletes, rewrites.
- Use terminal-friendly summaries.

Memory:
- Always maintain `work.md` for non-trivial tasks.
- Read `work.md` before continuing work.
- Update `work.md` after planning, edits, tests.

Team:
- Yui: Orchestrator — routes tasks, Auto/Step mode
- Fha: Planner — specs, architecture
- Masa: Logic — data flow, algorithms
- Eria: UI — design, components
- Mochi: PM — tasks, deadlines, tracking
'@
    Set-Content -Path $agentsMd -Value $agentsContent -Encoding UTF8
    Write-Log "  Created: AGENTS.md"
}

# ----- .gitignore -----
$gitignore = Join-Path $TargetDir ".gitignore"
if (-not (Test-Path $gitignore)) {
    $giContent = @'
node_modules/
.next/
dist/
build/
coverage/
.cache/
.DS_Store
*.log
.opencode/
'@
    Set-Content -Path $gitignore -Value $giContent -Encoding UTF8
    Write-Log "  Created: .gitignore"
}

# ----- Git init -----
if (-not $NoGit) {
    $gitDir = Join-Path $TargetDir ".git"
    if (-not (Test-Path $gitDir)) {
        Write-Log "Initializing git repository..."
        Set-Location -LiteralPath $TargetDir
        git init -q
        git add -A
        git commit -q -m "chore: init project with NEY Coder AI system"
        Write-Log "  Git initialized + initial commit"
    } else {
        Write-Log "  Git already initialized (skipped)"
    }
} else {
    Write-Log "  Git init skipped (--NoGit)"
}

# ----- Done -----
Write-Host ""
Write-Host "╭─────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│   Project Init Complete!                    │" -ForegroundColor Cyan
Write-Host "╰─────────────────────────────────────────────╯" -ForegroundColor Cyan
Write-Host ""

Write-Log "Project: $ProjectName"
Write-Log "Target:  $TargetDir"
Write-Host ""
Write-Info "Structure created:"
Write-Host "  ├── work.md              # session memory"
Write-Host "  ├── AGENTS.md            # agent instructions"
Write-Host "  ├── memory/              # long-term memory"
Write-Host "  ├── archive/             # archive log"
Write-Host "  ├── docs/                # plans + designs"
Write-Host "  └── .opencode/           # OpenCode config + skills"
Write-Host ""
Write-Info "Next steps:"
Write-Host "  1. cd $TargetDir"
Write-Host "  2. opencode"
Write-Host ""
