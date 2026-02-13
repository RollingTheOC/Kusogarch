#!/bin/bash
# Kusogarch - Surface power management
# Only sourced when KUSOGARCH_MODE=surface

log_info "Configuring Surface power management..."

# Enable power-profiles-daemon for easy power mode switching
enable_service power-profiles-daemon

# Remove TLP if present (conflicts with power-profiles-daemon)
if pacman -Qi tlp &>/dev/null; then
    log_step "Removing TLP (conflicts with power-profiles-daemon)"
    sudo pacman -Rns --noconfirm tlp 2>/dev/null || true
fi

# Surface-specific kernel parameters for better battery life
# mem_sleep_default=deep enables S3 deep sleep on supported Surface devices
SURFACE_CMDLINE="mem_sleep_default=deep"

# Apply to systemd-boot entries if present
if [ -d /boot/loader/entries ]; then
    for entry in /boot/loader/entries/*surface*.conf; do
        if [ -f "$entry" ]; then
            if ! grep -q "mem_sleep_default" "$entry"; then
                sudo sed -i "s|^options .*|& $SURFACE_CMDLINE|" "$entry"
                log_step "Added deep sleep param to $(basename "$entry")"
            fi
        fi
    done
fi

log_success "Surface power management configured"
