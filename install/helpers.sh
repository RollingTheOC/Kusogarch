#!/bin/bash
# Kusogarch - Shared helper functions
# Sourced by install.sh before all phases

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_phase() {
    echo ""
    echo -e "${MAGENTA}${BOLD}========================================${NC}"
    echo -e "${MAGENTA}${BOLD}  $1${NC}"
    echo -e "${MAGENTA}${BOLD}========================================${NC}"
    echo ""
}

log_step() {
    echo -e "${CYAN}  -> ${NC}$1"
}

# Prompt user for yes/no (default yes)
confirm() {
    local prompt="${1:-Continue?}"
    read -p "$(echo -e "${YELLOW}$prompt [Y/n]:${NC} ")" response
    case "$response" in
        [nN][oO]|[nN]) return 1 ;;
        *) return 0 ;;
    esac
}

# Prompt user for a choice
choose() {
    local prompt="$1"
    shift
    local options=("$@")

    echo -e "${YELLOW}$prompt${NC}"
    for i in "${!options[@]}"; do
        echo "  $((i+1))) ${options[$i]}"
    done
    echo ""

    local choice
    while true; do
        read -p "  Select [1-${#options[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "$choice"
            return 0
        fi
        echo "  Invalid choice. Try again."
    done
}

# Check if a command exists
cmd_exists() {
    command -v "$1" &>/dev/null
}

# Install packages via pacman (skip already installed)
pkg_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

# Install packages via yay (skip already installed)
aur_install() {
    yay -S --needed --noconfirm "$@"
}

# Enable a systemd service
enable_service() {
    local service="$1"
    sudo systemctl enable "$service" 2>/dev/null
    log_step "Enabled service: $service"
}

# Enable a systemd user service
enable_user_service() {
    local service="$1"
    systemctl --user enable "$service" 2>/dev/null
    log_step "Enabled user service: $service"
}

# Copy file only if destination doesn't exist
copy_no_overwrite() {
    local src="$1"
    local dst="$2"
    if [ ! -f "$dst" ]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        log_step "Deployed: $dst"
    else
        log_step "Skipped (exists): $dst"
    fi
}

# Copy file, always overwrite
copy_force() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    log_step "Deployed: $dst"
}

# Read package list from file (skip comments and blanks)
read_packages() {
    local file="$1"
    grep -v '^#' "$file" | grep -v '^\s*$' | tr '\n' ' '
}

# ASCII banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'BANNER'
  _  __                                    _
 | |/ /   _ ___  ___   __ _  __ _ _ __ ___| |__
 | ' / | | / __|/ _ \ / _` |/ _` | '__/ __| '_ \
 | . \ |_| \__ \ (_) | (_| | (_| | | | (__| | | |
 |_|\_\__,_|___/\___/ \__, |\__,_|_|  \___|_| |_|
                       |___/
BANNER
    echo -e "${NC}"
    echo -e "  ${BOLD}Omarchy-inspired Arch Linux Setup${NC}"
    echo -e "  ${BOLD}Version $(cat "$KUSOGARCH_DIR/version")${NC}"
    echo ""
}

# === Hardware detection accessors ===
# Check env vars first (set during install), fall back to saved files (for resume/scripts)

KUSOGARCH_STATE_DIR="$HOME/.config/kusogarch"

is_vm() {
    local val="${KUSOGARCH_VM:-}"
    if [ -z "$val" ] && [ -f "$KUSOGARCH_STATE_DIR/vm" ]; then
        val=$(cat "$KUSOGARCH_STATE_DIR/vm")
    fi
    [ "$val" = "true" ]
}

get_vm_type() {
    local val="${KUSOGARCH_VM_TYPE:-}"
    if [ -z "$val" ] && [ -f "$KUSOGARCH_STATE_DIR/vm_type" ]; then
        val=$(cat "$KUSOGARCH_STATE_DIR/vm_type")
    fi
    echo "$val"
}

is_surface() {
    local val="${KUSOGARCH_IS_SURFACE:-}"
    if [ -z "$val" ] && [ -f "$KUSOGARCH_STATE_DIR/is_surface" ]; then
        val=$(cat "$KUSOGARCH_STATE_DIR/is_surface")
    fi
    [ "$val" = "true" ]
}

get_gpu() {
    local val="${KUSOGARCH_GPU:-}"
    if [ -z "$val" ] && [ -f "$KUSOGARCH_STATE_DIR/gpu" ]; then
        val=$(cat "$KUSOGARCH_STATE_DIR/gpu")
    fi
    echo "$val"
}

get_cpu() {
    local val="${KUSOGARCH_CPU:-}"
    if [ -z "$val" ] && [ -f "$KUSOGARCH_STATE_DIR/cpu" ]; then
        val=$(cat "$KUSOGARCH_STATE_DIR/cpu")
    fi
    echo "$val"
}

get_mode() {
    local val="${KUSOGARCH_MODE:-}"
    if [ -z "$val" ] && [ -f "$KUSOGARCH_STATE_DIR/mode" ]; then
        val=$(cat "$KUSOGARCH_STATE_DIR/mode")
    fi
    echo "$val"
}

# === Checkpoint / Resume system ===

KUSOGARCH_CHECKPOINT_FILE="$HOME/.config/kusogarch/checkpoint"

# Initialize checkpoint file (clear previous state unless resuming)
checkpoint_init() {
    mkdir -p "$HOME/.config/kusogarch"
    if [ "${KUSOGARCH_RESUME:-false}" != "true" ]; then
        rm -f "$KUSOGARCH_CHECKPOINT_FILE"
        touch "$KUSOGARCH_CHECKPOINT_FILE"
    else
        if [ ! -f "$KUSOGARCH_CHECKPOINT_FILE" ]; then
            log_warn "No checkpoint file found — starting fresh install"
            touch "$KUSOGARCH_CHECKPOINT_FILE"
            export KUSOGARCH_RESUME=false
        else
            log_info "Resuming from checkpoint file"
        fi
    fi
}

# Mark a phase as completed
checkpoint_mark() {
    echo "$1" >> "$KUSOGARCH_CHECKPOINT_FILE"
}

# Check if a phase was already completed
checkpoint_done() {
    grep -qxF "$1" "$KUSOGARCH_CHECKPOINT_FILE" 2>/dev/null
}

# Run a phase only if not already checkpointed
run_phase() {
    local phase_id="$1"
    local phase_label="$2"
    local phase_script="$3"

    if [ "${KUSOGARCH_RESUME:-false}" = "true" ] && checkpoint_done "$phase_id"; then
        log_phase "$phase_label"
        log_success "Already completed (skipping)"
        return 0
    fi

    log_phase "$phase_label"
    source "$phase_script"
    checkpoint_mark "$phase_id"
}
