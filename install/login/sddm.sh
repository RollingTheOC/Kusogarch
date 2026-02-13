#!/bin/bash
# Kusogarch - SDDM Display Manager configuration

log_info "Configuring SDDM display manager..."

enable_service sddm

# Configure SDDM for Hyprland/Wayland
sudo mkdir -p /etc/sddm.conf.d
cat << 'EOF' | sudo tee /etc/sddm.conf.d/kusogarch.conf >/dev/null
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=Hyprland

[Autologin]
User=
Session=hyprland
EOF

# If disk encryption is in use, enable autologin
# (the LUKS passphrase already authenticates the user)
if lsblk -o TYPE 2>/dev/null | grep -q "crypt"; then
    log_step "Disk encryption detected, enabling SDDM autologin..."
    sudo sed -i "s/^User=$/User=$USER/" /etc/sddm.conf.d/kusogarch.conf
fi

log_success "SDDM configured"
