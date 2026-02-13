#!/bin/bash
# Kusogarch - Plymouth boot splash

log_info "Configuring Plymouth boot splash..."

# Add plymouth to mkinitcpio HOOKS if not present
if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
    # Insert plymouth after base and udev
    sudo sed -i 's/\(HOOKS=.*\)udev/\1udev plymouth/' /etc/mkinitcpio.conf
    log_step "Added plymouth to mkinitcpio HOOKS"

    # Rebuild initramfs
    sudo mkinitcpio -P
    log_step "Rebuilt initramfs with Plymouth"
fi

# Set plymouth theme
if command -v plymouth-set-default-theme &>/dev/null; then
    sudo plymouth-set-default-theme -R bgrt 2>/dev/null || \
    sudo plymouth-set-default-theme -R spinner 2>/dev/null || true
    log_step "Set Plymouth theme"
fi

# Add quiet splash to kernel cmdline for systemd-boot
if [ -d /boot/loader/entries ]; then
    for entry in /boot/loader/entries/*.conf; do
        if [ -f "$entry" ]; then
            if ! grep -q "quiet splash" "$entry"; then
                sudo sed -i 's/^options .*/& quiet splash/' "$entry"
            fi
        fi
    done
    log_step "Added quiet splash to boot entries"
fi

log_success "Plymouth configured"
