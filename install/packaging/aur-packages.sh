#!/bin/bash
# Kusogarch - Install AUR packages

log_info "Installing AUR packages..."

# Walker (app launcher) - not in official repos
aur_install walker-bin

# Satty (screenshot annotation) - may need AUR
if ! pacman -Qi satty &>/dev/null; then
    aur_install satty
fi

log_success "AUR packages installed"
