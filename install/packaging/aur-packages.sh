#!/bin/bash
# Kusogarch - Install AUR packages

log_info "Installing AUR packages..."

# Walker (app launcher)
aur_install walker-bin

# Satty (screenshot annotation)
if ! pacman -Qi satty &>/dev/null; then
    aur_install satty
fi

# Claude Desktop
aur_install claude-desktop-bin

# Winboat (Windows app runner)
aur_install winboat-bin

# LocalSend (local file sharing)
aur_install localsend-bin

# Mullvad VPN
aur_install mullvad-vpn-bin

# Spotify
aur_install spotify

log_success "AUR packages installed"
