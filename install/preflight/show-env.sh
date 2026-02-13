#!/bin/bash
# Kusogarch - Display system environment info

log_info "System Environment"
log_step "User: $USER"
log_step "Home: $HOME"
log_step "Shell: $SHELL"
log_step "Arch: $(uname -m)"
log_step "Kernel: $(uname -r)"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    log_step "OS: $PRETTY_NAME"
fi

# Check for EFI (required for systemd-boot)
if [ -d /sys/firmware/efi ]; then
    log_step "Boot mode: UEFI"
    export KUSOGARCH_UEFI=true
else
    log_warn "Boot mode: BIOS (systemd-boot requires UEFI)"
    log_warn "Surface devices are always UEFI - if this is wrong, check your BIOS settings"
    export KUSOGARCH_UEFI=false
fi

# Check internet connectivity
if ping -c 1 archlinux.org &>/dev/null; then
    log_step "Internet: Connected"
else
    log_error "No internet connection detected!"
    log_error "Kusogarch requires internet to install packages."
    exit 1
fi

# Check disk space (need at least 10GB free on /)
ROOT_FREE=$(df / --output=avail -BG | tail -1 | tr -dc '0-9')
log_step "Free space on /: ${ROOT_FREE}GB"
if [ "$ROOT_FREE" -lt 10 ]; then
    log_warn "Less than 10GB free. Installation may fail if disk space runs out."
fi
