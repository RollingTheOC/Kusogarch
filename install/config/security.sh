#!/bin/bash
# Kusogarch - Firewall configuration

log_info "Configuring firewall..."

# Enable UFW service (starts on next boot)
enable_service ufw

# UFW commands require the daemon to be running.
# Start it now, configure rules, then it persists across reboots.
if sudo ufw status &>/dev/null; then
    sudo ufw default deny incoming 2>/dev/null || true
    sudo ufw default allow outgoing 2>/dev/null || true
    sudo ufw allow ssh 2>/dev/null || true
    sudo ufw --force enable 2>/dev/null || true
    log_success "Firewall configured (UFW)"
else
    log_warn "UFW not available yet — rules will apply after reboot"
fi
