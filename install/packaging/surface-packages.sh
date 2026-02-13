#!/bin/bash
# Kusogarch - Install Surface-specific packages

if [ "$KUSOGARCH_MODE" != "surface" ]; then
    log_info "Skipping Surface packages (desktop mode)"
    return 0
fi

log_info "Installing Surface-specific packages..."

PACKAGES=$(read_packages "$KUSOGARCH_DIR/install/kusogarch-surface.packages")

if [ -n "$PACKAGES" ]; then
    pkg_install $PACKAGES
    log_success "Surface packages installed"
fi
