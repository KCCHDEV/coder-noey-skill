#!/usr/bin/env bash
# ============================================================
# NEY Coder AI — Init Project
# Sets up a new or existing project with NEY agent system
# Creates: work.md, memory/, archive/, docs/, .opencode/
# Supports: Linux, macOS, Windows (Git Bash / WSL)
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[NEV]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERR]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

NEV_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR=""
PROJECT_NAME=""
INIT_GIT=true
LINK_MODE=true
NEV_VARIANT="SKILL"   # or "mini"
NEV_AGENTS="all"

REPO_URL="https://github.com/KCCHDEV/coder-noey-skill"
RAW_URL="https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"

# Detect if running from NEY repo
IN_REPO=false
if [ -f "$NEV_REPO/agents/ney/SKILL.md" ]; then
    IN_REPO=true
fi

usage() {
    echo "Usage: $0 [options] [project-dir]"
    echo ""
    echo "Options:"
    echo "  --name <name>      Project name (default: dir name)"
    echo "  --no-git           Skip git init"
    echo "  --copy             Copy files instead of symlink"
    echo "  --mini             Use compact SKILL (mini.md)"
    echo "  --agents <list>    Agents to install: all or comma-sep (e.g. ney,fha,masa)"
    echo "  --help             Show this help"
    echo ""
    echo "If project-dir is omitted, uses current directory."
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --name) PROJECT_NAME="$2"; shift 2 ;;
        --mini) NEV_VARIANT="mini"; shift ;;
        --agents) NEV_AGENTS="$2"; shift 2 ;;
        --no-git) INIT_GIT=false; shift ;;
        --copy) LINK_MODE=false; shift ;;
        --help|-h) usage ;;
        *) TARGET_DIR="$1"; shift ;;
    esac
done

# ----- Determine target -----
if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR="$(pwd)"
fi

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    mkdir -p "$TARGET_DIR"
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
}

if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME="$(basename "$TARGET_DIR")"
fi

echo ""
echo -e "${CYAN}╭─────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│   NEY Coder AI — Init Project               │${NC}"
echo -e "${CYAN}│   Project: ${PROJECT_NAME}${NC}"
echo -e "${CYAN}│   Target:  ${TARGET_DIR}${NC}"
echo -e "${CYAN}╰─────────────────────────────────────────────╯${NC}"
echo ""

# ----- Check if already initialized -----
if [ -f "$TARGET_DIR/work.md" ]; then
    warn "work.md already exists — project may already be initialized."
    echo -n "Continue anyway? [y/N] "
    read -r answer
    if [[ ! "$answer" =~ ^[Yy] ]]; then
        log "Aborted."
        exit 0
    fi
fi

# ----- Create structure -----
log "Creating project structure..."

mkdir -p "$TARGET_DIR/memory"
mkdir -p "$TARGET_DIR/archive"
mkdir -p "$TARGET_DIR/docs/plans"
mkdir -p "$TARGET_DIR/docs/designs"

# ----- work.md -----
log "Creating work.md..."
cat > "$TARGET_DIR/work.md" << EOF
# work.md — ${PROJECT_NAME}

> Auto-created by NEY Coder AI Init Project

## Current Status

- State: active
- Last updated: $(date +%Y-%m-%d)
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
EOF

log "  Created: work.md"

# ----- startup.md -----
cat > "$TARGET_DIR/startup.md" << 'EOF'
# Startup — Project Entry Point

> AI Agent: อ่านไฟล์นี้ก่อนเริ่มทำงาน

## Read Order
1. startup.md (ไฟล์นี้)
2. work.md
3. memory/mem.md
4. AGENTS.md
5. .opencode/skills/<your-agent>/SKILL.md

## Team
- Yui: Orchestrator — routes tasks
- Ney: DEV — implement
- Fha: Planner — spec
- Masa: Logic — design
- Eria: UI — design
- Mochi: PM — manage

## Rules
- No Chinese — Thai + English only
- Update work.md after every action
- Archive before deleting code
EOF
log "  Created: startup.md"

# ----- memory/mem.md -----
log "Creating memory files..."
cat > "$TARGET_DIR/memory/mem.md" << 'EOF'
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
EOF

cat > "$TARGET_DIR/memory/summary.md" << 'EOF'
# Summary — Project Overview

## Tech Stack

- ...

## Structure

```
├── work.md
├── memory/
├── archive/
└── docs/
```

## Team

- Ney (DEV) — implement
- Fha (plan) — spec
- Masa (logic) — design
- Eria (UI) — design
- Yui (orchestrate) — route
- Mochi (PM) — manage
EOF

log "  Created: memory/mem.md + memory/summary.md"

# ----- ARCHIVE_LOG.md -----
cat > "$TARGET_DIR/archive/ARCHIVE_LOG.md" << 'EOF'
# ARCHIVE_LOG.md

> Log of all archived/replaced files

| Date | File | Reason | Restore |
|---|---|---|---|
EOF

log "  Created: archive/ARCHIVE_LOG.md"

# ----- .opencode/skills/ -----
log "Setting up OpenCode skills..."

mkdir -p "$TARGET_DIR/.opencode/skills"

if [ "$NEV_AGENTS" = "all" ]; then
    AGENTS=("yui" "ney" "fha" "masa" "eria" "mochi")
else
    IFS=',' read -ra AGENTS <<< "$NEV_AGENTS"
fi

VARIANT_FILE="$NEV_VARIANT"
# mini mode uses mini.md, full uses SKILL.md
[ "$VARIANT_FILE" = "mini" ] || VARIANT_FILE="SKILL"

download_skill() {
    local agent="$1" variant="$2" out="$3"
    mkdir -p "$(dirname "$out")"

    if [ "$IN_REPO" = true ]; then
        local src="$NEV_REPO/agents/$agent/$variant.md"
        [ ! -f "$src" ] && src="$NEV_REPO/agents/$agent/SKILL.md"
        if [ -f "$src" ]; then
            if [ "$LINK_MODE" = true ] && [ "$(uname -s)" != "MINGW"* ]; then
                ln -sf "$src" "$out"
            else
                cp "$src" "$out"
            fi
            return 0
        fi
        return 1
    fi

    # Download from GitHub
    local url="$RAW_URL/agents/$agent/$variant.md"
    if command -v curl &>/dev/null; then
        curl -sL "$url" -o "$out" && return 0
    elif command -v wget &>/dev/null; then
        wget -q "$url" -O "$out" && return 0
    fi
    return 1
}

for agent in "${AGENTS[@]}"; do
    agent="$(echo "$agent" | xargs)"  # trim
    dst="$TARGET_DIR/.opencode/skills/$agent/SKILL.md"
    if download_skill "$agent" "$VARIANT_FILE" "$dst"; then
        log "  $([ "$VARIANT_FILE" = "mini" ] && echo "Mini" || echo "Full"): $agent → .opencode/skills/$agent/"
    else
        warn "  Skipping $agent — source not found"
    fi
done

# ----- .opencode/opencode.json -----
if [ ! -f "$TARGET_DIR/.opencode/opencode.json" ]; then
    cat > "$TARGET_DIR/.opencode/opencode.json" << 'JSONEOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/deepseek-v4-flash",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": {
    "*": "allow"
  }
}
JSONEOF
    log "  Created: .opencode/opencode.json"
else
    warn "  Config exists: .opencode/opencode.json (skipped)"
fi

# ----- AGENTS.md -----
if [ ! -f "$TARGET_DIR/AGENTS.md" ]; then
    cat > "$TARGET_DIR/AGENTS.md" << 'EOFEOF'
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
EOFEOF
    log "  Created: AGENTS.md"
fi

# ----- .gitignore -----
if [ ! -f "$TARGET_DIR/.gitignore" ]; then
    cat > "$TARGET_DIR/.gitignore" << 'GIEOF'
node_modules/
.next/
dist/
build/
coverage/
.cache/
.DS_Store
*.log
.opencode/
GIEOF
    log "  Created: .gitignore"
fi

# ----- Git init -----
if [ "$INIT_GIT" = true ] && [ ! -d "$TARGET_DIR/.git" ]; then
    log "Initializing git repository..."
    cd "$TARGET_DIR"
    git init -q
    git add -A
    git commit -q -m "chore: init project with NEY Coder AI system"
    log "  Git initialized + initial commit"
elif [ "$INIT_GIT" = true ]; then
    log "  Git already initialized (skipped)"
else
    log "  Git init skipped (--no-git)"
fi

# ----- Done -----
echo ""
echo -e "${CYAN}╭─────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│   Project Init Complete!                    │${NC}"
echo -e "${CYAN}╰─────────────────────────────────────────────╯${NC}"
echo ""

log "Project: $PROJECT_NAME"
log "Target:  $TARGET_DIR"
echo ""
info "Structure created:"
echo "  ├── work.md              # session memory"
echo "  ├── AGENTS.md            # agent instructions"
echo "  ├── memory/"
echo "  │   ├── mem.md           # long-term memory"
echo "  │   └── summary.md       # project overview"
echo "  ├── archive/"
echo "  │   └── ARCHIVE_LOG.md   # archive log"
echo "  ├── docs/"
echo "  │   ├── plans/           # Fha's specs"
echo "  │   └── designs/         # Masa + Eria designs"
echo "  └── .opencode/"
echo "      ├── opencode.json    # config"
echo "      └── skills/          # agent skills"
echo ""
info "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. opencode"
echo ""
