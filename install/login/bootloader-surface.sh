#!/bin/bash
# Kusogarch - systemd-boot entry for linux-surface kernel
# Only sourced when KUSOGARCH_MODE=surface

log_info "Configuring systemd-boot for linux-surface kernel..."

if [ ! -d /boot/loader/entries ]; then
    log_warn "systemd-boot not found at /boot/loader/entries"
    log_warn "Skipping bootloader configuration. You may need to configure manually."
    return 0
fi

# Detect root partition UUID
ROOT_PARTUUID=$(findmnt -no PARTUUID / 2>/dev/null)
ROOT_UUID=$(findmnt -no UUID / 2>/dev/null)

if [ -z "$ROOT_PARTUUID" ] && [ -z "$ROOT_UUID" ]; then
    log_warn "Could not detect root partition UUID"
    log_warn "You will need to manually edit the boot entry"
    ROOT_PARAM="root=/dev/sdXn"
else
    if [ -n "$ROOT_PARTUUID" ]; then
        ROOT_PARAM="root=PARTUUID=$ROOT_PARTUUID"
    else
        ROOT_PARAM="root=UUID=$ROOT_UUID"
    fi
fi

# Detect initrd images
INITRD_LINES=""
if [ -f /boot/intel-ucode.img ]; then
    INITRD_LINES="initrd  /intel-ucode.img"
elif [ -f /boot/amd-ucode.img ]; then
    INITRD_LINES="initrd  /amd-ucode.img"
fi
INITRD_LINES="$INITRD_LINES
initrd  /initramfs-linux-surface.img"

# Create linux-surface boot entry
cat << EOF | sudo tee /boot/loader/entries/linux-surface.conf >/dev/null
title   Arch Linux (Surface Kernel)
linux   /vmlinuz-linux-surface
${INITRD_LINES}
options ${ROOT_PARAM} rw mem_sleep_default=deep quiet splash
EOF
log_step "Created boot entry: linux-surface.conf"

# Create fallback entry
cat << EOF | sudo tee /boot/loader/entries/linux-surface-fallback.conf >/dev/null
title   Arch Linux (Surface Kernel - Fallback)
linux   /vmlinuz-linux-surface
${INITRD_LINES%surface.img*}surface-fallback.img
options ${ROOT_PARAM} rw mem_sleep_default=deep
EOF
log_step "Created fallback boot entry"

# Set linux-surface as default boot entry
sudo sed -i 's/^default .*/default linux-surface.conf/' /boot/loader/loader.conf 2>/dev/null || \
    echo "default linux-surface.conf" | sudo tee -a /boot/loader/loader.conf >/dev/null
log_step "Set linux-surface as default boot entry"

log_success "systemd-boot configured for linux-surface"
