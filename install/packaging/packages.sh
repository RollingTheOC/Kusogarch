#!/bin/bash
# Kusogarch - Install base packages from package list

log_info "Installing base packages..."

PACKAGES=$(read_packages "$KUSOGARCH_DIR/install/kusogarch-base.packages")

if [ -n "$PACKAGES" ]; then
    pkg_install $PACKAGES
    log_success "Base packages installed"
else
    log_error "Package list is empty!"
    exit 1
fi
