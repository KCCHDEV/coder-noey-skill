#!/usr/bin/env bash
# ============================================================
# NEY Coder AI — Cross-Platform Auto Setup
# Auto-downloads skills from GitHub if not in repo
# Supports: full SKILL.md or mini SKILL.md per agent
# Interactive agent selection
# ============================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log()  { echo -e "${GREEN}[NEV]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERR]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

# ----- Config -----
REPO_URL="https://github.com/KCCHDEV/coder-noey-skill"
RAW_URL="https://raw.githubusercontent.com/KCCHDEV/coder-noey-skill/main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IN_REPO=false

# Detect if we're inside the NEY repo
if [ -f "$SCRIPT_DIR/agents/ney/SKILL.md" ]; then
    IN_REPO=true
fi

declare -A AGENT_NAMES AGENT_DESCS
AGENT_NAMES=( [1]="ney" [2]="fha" [3]="masa" [4]="eria" [5]="yui" [6]="mochi" )
AGENT_DESCS=(
    [1]="Ney   — DEV Implementer"
    [2]="Fha   — Project Planner"
    [3]="Masa  — Logic Designer"
    [4]="Eria  — UI/UX Designer"
    [5]="Yui   — Orchestrator (entry point)"
    [6]="Mochi — Project Manager"
)

echo ""
echo -e "${CYAN}╭─────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│   NEY Coder AI — Auto Setup                  │${NC}"
echo -e "${CYAN}╰─────────────────────────────────────────────╯${NC}"
echo ""

# ----- Auto-download if not in repo -----
if [ "$IN_REPO" = false ]; then
    log "Not in NEY repo — will download from GitHub"
    log "  Repo: $REPO_URL"
    echo ""
    info "Option 1: Clone entire repo (recommended)"
    info "Option 2: Download individual skills only"
    echo -n "Choose [1/2]: "; read -r clone_choice
    echo ""

    case "$clone_choice" in
        2)
            log "Will download individual skill files"
            DOWNLOAD_DIR=$(mktemp -d)
            ;;
        *)
            log "Cloning repository..."
            DOWNLOAD_DIR=$(mktemp -d)
            if command -v git &>/dev/null; then
                git clone --depth 1 "$REPO_URL" "$DOWNLOAD_DIR" 2>&1 | tail -1
                SCRIPT_DIR="$DOWNLOAD_DIR"
                IN_REPO=true
                log "Cloned to $DOWNLOAD_DIR"
            else
                err "git not found — falling back to individual downloads"
                DOWNLOAD_DIR=$(mktemp -d)
            fi
            ;;
    esac
else
    log "Running from NEY repo: $SCRIPT_DIR"
    DOWNLOAD_DIR="$SCRIPT_DIR"
fi

# ----- Download agent file -----
download_skill() {
    local agent="$1" variant="$2" out="$3"
    local url="$RAW_URL/agents/$agent/$variant.md"
    mkdir -p "$(dirname "$out")"

    if [ "$IN_REPO" = true ]; then
        cp "$SCRIPT_DIR/agents/$agent/$variant.md" "$out" 2>/dev/null && return 0
        # fallback: if variant=SKILL and mini doesn't exist, use SKILL
        cp "$SCRIPT_DIR/agents/$agent/SKILL.md" "$out" 2>/dev/null && return 0
        return 1
    fi

    if command -v curl &>/dev/null; then
        curl -sL "$url" -o "$out" && return 0
    elif command -v wget &>/dev/null; then
        wget -q "$url" -O "$out" && return 0
    fi
    return 1
}

# ----- Select agents -----
select_agents() {
    echo ""
    info "Available agents:"
    for i in {1..6}; do
        echo "  $i) ${AGENT_DESCS[$i]}"
    done
    echo "  7) ALL agents"
    echo ""
    echo -n "Select agents (comma-separated, e.g. 1,3,5 or 7 for all): "
    read -r selection

    local selected=()
    if [ "$selection" = "7" ]; then
        selected=(1 2 3 4 5 6)
    else
        IFS=',' read -ra nums <<< "$selection"
        for n in "${nums[@]}"; do
            n=$(echo "$n" | xargs)
            if [[ "$n" =~ ^[1-6]$ ]]; then
                selected+=("$n")
            fi
        done
    fi
    echo "${selected[@]}"
}

# ----- Select variant -----
select_variant() {
    echo ""
    info "Skill variant:"
    echo "  1) Full — complete SKILL.md (detailed)"
    echo "  2) Mini — compact SKILL.md (~30 lines)"
    echo -n "Choose [1/2]: "; read -r v
    if [ "$v" = "2" ]; then echo "mini"; else echo "SKILL"; fi
}

# ===== Main =====
AGENTS_SELECTED=$(select_agents)
VARIANT=$(select_variant)

echo ""
log "Installing ${VARIANT} skills for selected agents..."
echo ""

for idx in $AGENTS_SELECTED; do
    agent="${AGENT_NAMES[$idx]}"
    desc="${AGENT_DESCS[$idx]}"
    variant_file="$VARIANT"

    # If full not available, fallback to mini logic: use mini.md
    # If mini not available, use SKILL.md
    if [ "$VARIANT" = "mini" ]; then
        variant_file="mini"
    fi

    OPENCODE_DIR="${SCRIPT_DIR}/.opencode"
    SKILLS_DIR="${OPENCODE_DIR}/skills"
    mkdir -p "$SKILLS_DIR/$agent"

    dst="$SKILLS_DIR/$agent/SKILL.md"
    if download_skill "$agent" "$variant_file" "$dst"; then
        log "  ✅ $desc → .opencode/skills/$agent/"
    else
        warn "  ⚠️  $desc — download failed, skipping"
    fi
done

# ----- Config -----
mkdir -p "$OPENCODE_DIR"
if [ ! -f "$OPENCODE_DIR/opencode.json" ]; then
    cat > "$OPENCODE_DIR/opencode.json" << 'JSONEOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/deepseek-v4-flash",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": { "*": "allow" }
}
JSONEOF
    log "  Created: opencode.json"
fi

# ----- .gitignore -----
if [ -f "$SCRIPT_DIR/.gitignore" ]; then
    if ! grep -q ".opencode/" "$SCRIPT_DIR/.gitignore" 2>/dev/null; then
        echo ".opencode/" >> "$SCRIPT_DIR/.gitignore"
    fi
else
    echo ".opencode/" > "$SCRIPT_DIR/.gitignore"
fi

echo ""
echo -e "${CYAN}╭─────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│   Setup Complete!                           │${NC}"
echo -e "${CYAN}╰─────────────────────────────────────────────╯${NC}"
echo ""
log "Installed: $VARIANT skills"
for idx in $AGENTS_SELECTED; do
    echo "  • ${AGENT_DESCS[$idx]}"
done
echo ""
info "Start OpenCode:  opencode"
echo ""
