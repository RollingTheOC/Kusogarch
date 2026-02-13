#!/bin/bash
# Kusogarch - Surface-specific hardware configuration
# Only sourced when KUSOGARCH_MODE=surface

log_info "Configuring Surface-specific settings..."

# 1. Enable iptsd (Intel Precise Touch & Stylus Daemon)
enable_service iptsd

# 2. Configure mkinitcpio for Surface hardware
log_step "Configuring mkinitcpio for Surface hardware..."

# Core Surface Aggregator modules needed for keyboard/touchpad at boot
SURFACE_MODULES="surface_aggregator surface_aggregator_registry surface_aggregator_hub surface_hid_core surface_hid 8250_dw"

# Add CPU-specific GPIO modules for type cover support
if [ "$KUSOGARCH_CPU" = "intel" ]; then
    if grep -qiE "11th|12th|13th|14th" /proc/cpuinfo 2>/dev/null; then
        SURFACE_MODULES="$SURFACE_MODULES intel_lpss intel_lpss_pci pinctrl_tigerlake"
    elif grep -qi "10th" /proc/cpuinfo 2>/dev/null; then
        SURFACE_MODULES="$SURFACE_MODULES intel_lpss intel_lpss_pci pinctrl_icelake"
    else
        SURFACE_MODULES="$SURFACE_MODULES intel_lpss intel_lpss_pci"
    fi
elif [ "$KUSOGARCH_CPU" = "amd" ]; then
    SURFACE_MODULES="$SURFACE_MODULES pinctrl_amd"
fi

# Back up mkinitcpio.conf
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.kusogarch-bak
log_step "Backed up mkinitcpio.conf"

# Read current MODULES line and merge in Surface modules
CURRENT_MODULES=$(grep '^MODULES=' /etc/mkinitcpio.conf | sed 's/MODULES=(\(.*\))/\1/')
MERGED_MODULES="$CURRENT_MODULES $SURFACE_MODULES"
# Deduplicate
MERGED_MODULES=$(echo "$MERGED_MODULES" | tr ' ' '\n' | sort -u | tr '\n' ' ' | xargs)

sudo sed -i "s/^MODULES=.*/MODULES=($MERGED_MODULES)/" /etc/mkinitcpio.conf
log_step "Added Surface modules to mkinitcpio: $SURFACE_MODULES"

# 3. Rebuild initramfs for linux-surface
sudo mkinitcpio -P
log_step "Rebuilt initramfs with Surface modules"

# 4. Configure iptsd for better touch experience
IPTSD_CONF="/etc/iptsd.conf"
if [ -f "$IPTSD_CONF" ]; then
    log_step "iptsd config exists at $IPTSD_CONF"
else
    log_step "iptsd will use default configuration"
fi

log_success "Surface hardware configuration complete"
