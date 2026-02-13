#!/bin/bash
# Kusogarch - TTY Autologin + Hyprland Auto-Start
# No display manager needed — boots straight into Hyprland.

log_info "Configuring TTY autologin..."

# Disable any existing display manager
for dm in sddm gdm lightdm; do
    if systemctl is-enabled "$dm" &>/dev/null; then
        sudo systemctl disable "$dm"
        log_step "Disabled $dm"
    fi
done

# Enable TTY1 autologin via systemd override
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
cat << EOF | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $USER %I \$TERM
EOF
log_step "TTY1 autologin enabled for $USER"

# Add Hyprland auto-start to .bash_profile (runs on login shell only)
PROFILE="$HOME/.bash_profile"
if [ ! -f "$PROFILE" ]; then
    touch "$PROFILE"
fi

if ! grep -q "Hyprland" "$PROFILE"; then
    cat >> "$PROFILE" << 'PROFEOF'

# Kusogarch - Auto-start Hyprland on TTY1
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
PROFEOF
    log_step "Hyprland auto-start added to .bash_profile"
fi

log_success "TTY autologin configured (no display manager)"
