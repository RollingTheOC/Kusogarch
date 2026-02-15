#!/bin/bash
# Kusogarch - Install AUR packages

log_info "Installing AUR packages..."

# Walker (app launcher)
aur_install walker-bin

# Satty (screenshot annotation)
if ! pacman -Qi satty &>/dev/null; then
    aur_install satty
fi

# ReGreet (GTK4 greeter for greetd)
aur_install greetd-regreet

# hyprqt6engine (Hyprland Qt6 platform theme - KColorScheme support)
aur_install hyprqt6engine

# Bluetuith (TUI bluetooth manager)
aur_install bluetuith-bin

# Winboat (Windows app runner)
aur_install winboat-bin

# LocalSend (local file sharing)
aur_install localsend-bin

# Mullvad VPN
aur_install mullvad-vpn-bin

# Spotify
aur_install spotify

log_success "AUR packages installed"
