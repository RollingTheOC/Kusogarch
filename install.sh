#!/bin/bash
# Kusogarch - Main Installation Orchestrator
# Sequences all installation phases
set -eEo pipefail

# Determine install directory
export KUSOGARCH_DIR="${KUSOGARCH_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export PATH="$KUSOGARCH_DIR/bin:$PATH"

# Parse command-line arguments
export KUSOGARCH_RESUME=false
for arg in "$@"; do
    case "$arg" in
        --resume) export KUSOGARCH_RESUME=true ;;
    esac
done

# Source helper functions
source "$KUSOGARCH_DIR/install/helpers.sh"

# Show banner
show_banner

# Initialize checkpoint system
checkpoint_init

# On resume, restore hardware detection state from saved files
if [ "$KUSOGARCH_RESUME" = "true" ]; then
    KUSOGARCH_STATE_DIR="$HOME/.config/kusogarch"
    [ -f "$KUSOGARCH_STATE_DIR/mode" ] && export KUSOGARCH_MODE=$(cat "$KUSOGARCH_STATE_DIR/mode")
    [ -f "$KUSOGARCH_STATE_DIR/gpu" ] && export KUSOGARCH_GPU=$(cat "$KUSOGARCH_STATE_DIR/gpu")
    [ -f "$KUSOGARCH_STATE_DIR/vm" ] && export KUSOGARCH_VM=$(cat "$KUSOGARCH_STATE_DIR/vm")
    [ -f "$KUSOGARCH_STATE_DIR/vm_type" ] && export KUSOGARCH_VM_TYPE=$(cat "$KUSOGARCH_STATE_DIR/vm_type")
    [ -f "$KUSOGARCH_STATE_DIR/cpu" ] && export KUSOGARCH_CPU=$(cat "$KUSOGARCH_STATE_DIR/cpu")
    [ -f "$KUSOGARCH_STATE_DIR/is_surface" ] && export KUSOGARCH_IS_SURFACE=$(cat "$KUSOGARCH_STATE_DIR/is_surface")
    log_info "Restored hardware state from previous run"
fi

# Confirm before proceeding
if [ "$KUSOGARCH_RESUME" = "true" ]; then
    echo "  Resuming installation from last checkpoint."
    echo ""
    if ! confirm "Continue resumed installation?"; then
        echo "Installation cancelled."
        exit 0
    fi
else
    echo "  This script will configure your Arch Linux installation with:"
    echo "    - Hyprland (Wayland compositor)"
    echo "    - Kitty terminal, Waybar, Walker launcher"
    echo "    - fzf-based package management applets"
    echo "    - Theme system with multiple built-in themes"
    echo "    - Optional Microsoft Surface hardware support"
    echo ""
    if ! confirm "Ready to begin installation?"; then
        echo "Installation cancelled."
        exit 0
    fi
fi

# Track start time
INSTALL_START=$(date +%s)

# === Run all phases (checkpoint system skips completed phases on --resume) ===
run_phase "phase1_preflight"    "Phase 1: Preflight"    "$KUSOGARCH_DIR/install/preflight/all.sh"
run_phase "phase2_packaging"    "Phase 2: Packaging"    "$KUSOGARCH_DIR/install/packaging/all.sh"
run_phase "phase3_configuration" "Phase 3: Configuration" "$KUSOGARCH_DIR/install/config/all.sh"
run_phase "phase4_login"        "Phase 4: Login"        "$KUSOGARCH_DIR/install/login/all.sh"
run_phase "phase5_postinstall"  "Phase 5: Post-Install" "$KUSOGARCH_DIR/install/post-install/all.sh"

# Calculate elapsed time
INSTALL_END=$(date +%s)
INSTALL_ELAPSED=$(( INSTALL_END - INSTALL_START ))
INSTALL_MINUTES=$(( INSTALL_ELAPSED / 60 ))
INSTALL_SECONDS=$(( INSTALL_ELAPSED % 60 ))

echo ""
log_success "Installation complete! (${INSTALL_MINUTES}m ${INSTALL_SECONDS}s)"
echo ""
echo "  Reboot to start using Kusogarch."
echo ""

if confirm "Reboot now?"; then
    sudo reboot
fi
