#!/usr/bin/env bash
# ============================================================
# NEY Coder AI — Cross-Platform Auto Setup
# Detects OS, installs agent skills, configures OpenCode
# Supports: Linux, macOS, Windows (Git Bash / WSL)
# ============================================================

set -euo pipefail

# ----- Colors -----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[NEV]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERR]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

# ----- Detect OS -----
detect_os() {
    case "$(uname -s)" in
        Linux*)   echo "linux" ;;
        Darwin*)  echo "macos" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)        echo "unknown" ;;
    esac
}

OS=$(detect_os)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${CYAN}╭─────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│   NEY Coder AI — Auto Setup                 │${NC}"
echo -e "${CYAN}│   OS: ${OS}${NC}"
echo -e "${CYAN}╰─────────────────────────────────────────────╯${NC}"
echo ""

# ----- Install targets -----
OPENCODE_DIR="$REPO_DIR/.opencode"
SKILLS_DIR="$OPENCODE_DIR/skills"

AGENTS=(
    "yui:Yui Orchestrator"
    "ney:Ney DEV Implementer"
    "fha:Fha Project Planner"
    "masa:Masa Logic Designer"
    "eria:Eria UI/UX Designer"
    "mochi:Mochi Project Manager"
)

install_skills() {
    log "Creating OpenCode skills directory..."
    mkdir -p "$SKILLS_DIR"

    for agent in "${AGENTS[@]}"; do
        name="${agent%%:*}"
        desc="${agent##*:}"
        src="$REPO_DIR/agents/$name/SKILL.md"
        dst="$SKILLS_DIR/$name/SKILL.md"

        if [ ! -f "$src" ]; then
            warn "Source not found: $src"
            continue
        fi

        mkdir -p "$(dirname "$dst")"

        if [ "$OS" = "windows" ]; then
            # Windows: copy (no symlink support in Git Bash easily)
            cp "$src" "$dst"
        else
            # Linux/macOS: symlink
            ln -sf "$src" "$dst"
        fi

        log "  Installed: $name → $dst"
    done

    # Also copy shared memory reference
    mkdir -p "$SKILLS_DIR/shared"
    cp -r "$REPO_DIR/shared/memory" "$SKILLS_DIR/shared/" 2>/dev/null || true

    log "Skills installed to $SKILLS_DIR"
}

create_config() {
    local cfg="$OPENCODE_DIR/opencode.json"
    if [ -f "$cfg" ]; then
        warn "Config already exists: $cfg"
        return
    fi

    log "Creating OpenCode config..."
    cat > "$cfg" << 'JSONEOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode-go/deepseek-v4-flash",
  "small_model": "opencode-go/deepseek-v4-flash",
  "permission": {
    "*": "allow"
  }
}
JSONEOF
    log "Config created: $cfg"
}

create_gitignore() {
    local gi="$REPO_DIR/.gitignore"
    if [ -f "$gi" ]; then
        if grep -q ".opencode/" "$gi" 2>/dev/null; then
            return
        fi
    fi
    log "Adding .opencode/ to .gitignore..."
    echo ".opencode/" >> "$gi"
}

print_summary() {
    echo ""
    echo -e "${CYAN}╭─────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│   Setup Complete!                           │${NC}"
    echo -e "${CYAN}╰─────────────────────────────────────────────╯${NC}"
    echo ""
    log "Agents installed:"
    for agent in "${AGENTS[@]}"; do
        name="${agent%%:*}"
        desc="${agent##*:}"
        echo "  • $name — $desc"
    done
    echo ""
    info "To start OpenCode:  opencode"
    info "To configure model: opencode.ps1 (Windows) or edit opencode.json"
    echo ""
    info "Next steps:"
    info "  1. cd $REPO_DIR"
    info "  2. opencode"
    echo ""
}

# ----- Main -----
echo ""
log "Starting setup for $OS..."
echo ""

install_skills
create_config
create_gitignore
print_summary
