#!/bin/bash
# Kusogarch - Install yay (AUR helper)

if cmd_exists yay; then
    log_info "yay is already installed"
    return 0
fi

log_info "Installing yay (AUR helper)..."

# Build yay from source
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd "$KUSOGARCH_DIR"
rm -rf "$TEMP_DIR"

log_success "yay installed"
