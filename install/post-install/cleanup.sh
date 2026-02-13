#!/bin/bash
# Kusogarch - Post-install cleanup

log_info "Cleaning up..."

# Clear pacman cache (keep only latest version)
sudo paccache -rk1 2>/dev/null || true
log_step "Cleaned pacman cache"

# Remove orphaned packages
ORPHANS=$(pacman -Qdtq 2>/dev/null)
if [ -n "$ORPHANS" ]; then
    sudo pacman -Rns --noconfirm $ORPHANS 2>/dev/null || true
    log_step "Removed orphaned packages"
fi

log_success "Cleanup complete"
