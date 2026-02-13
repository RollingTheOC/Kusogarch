#!/bin/bash
# Kusogarch - Main Installation Orchestrator
# Sequences all installation phases
set -eEo pipefail

# Determine install directory
export KUSOGARCH_DIR="${KUSOGARCH_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export PATH="$KUSOGARCH_DIR/bin:$PATH"

# Source helper functions
source "$KUSOGARCH_DIR/install/helpers.sh"

# Show banner
show_banner

# Confirm before proceeding
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

# Track start time
INSTALL_START=$(date +%s)

# === PHASE 1: PREFLIGHT ===
log_phase "Phase 1: Preflight"
source "$KUSOGARCH_DIR/install/preflight/all.sh"

# === PHASE 2: PACKAGING ===
log_phase "Phase 2: Packaging"
source "$KUSOGARCH_DIR/install/packaging/all.sh"

# === PHASE 3: CONFIGURATION ===
log_phase "Phase 3: Configuration"
source "$KUSOGARCH_DIR/install/config/all.sh"

# === PHASE 4: LOGIN ===
log_phase "Phase 4: Login"
source "$KUSOGARCH_DIR/install/login/all.sh"

# === PHASE 5: POST-INSTALL ===
log_phase "Phase 5: Post-Install"
source "$KUSOGARCH_DIR/install/post-install/all.sh"

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
