#!/bin/bash
# Kusogarch - Configure pacman repositories

log_info "Configuring package repositories..."

# Enable multilib (32-bit support)
if grep -q "^#\[multilib\]" /etc/pacman.conf; then
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    log_step "Enabled multilib repository"
fi

# Enable parallel downloads
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf

# Enable Color output
sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf

# Enable VerbosePkgLists
sudo sed -i 's/^#VerbosePkgLists$/VerbosePkgLists/' /etc/pacman.conf

# Add ILoveCandy easter egg
if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^Color$/a ILoveCandy' /etc/pacman.conf
    log_step "Added ILoveCandy to pacman.conf"
fi

# If Surface mode, add linux-surface repository
if [ "$KUSOGARCH_MODE" = "surface" ]; then
    log_info "Adding linux-surface repository..."

    # Import and sign the linux-surface GPG key
    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
        | sudo pacman-key --add -
    sudo pacman-key --finger 56C464BAAC421453
    sudo pacman-key --lsign-key 56C464BAAC421453
    log_step "Imported linux-surface signing key"

    # Add repository to pacman.conf (before [multilib] so it has priority)
    if ! grep -q "\[linux-surface\]" /etc/pacman.conf; then
        # Insert before [multilib] or at end
        if grep -q "^\[multilib\]" /etc/pacman.conf; then
            sudo sed -i '/^\[multilib\]/i [linux-surface]\nServer = https://pkg.surfacelinux.com/arch/\n' /etc/pacman.conf
        else
            echo -e "\n[linux-surface]\nServer = https://pkg.surfacelinux.com/arch/" \
                | sudo tee -a /etc/pacman.conf >/dev/null
        fi
        log_step "Added [linux-surface] repository"
    fi
fi

# Refresh package databases
log_info "Refreshing package databases..."
sudo pacman -Syyu --noconfirm

# Ensure base-devel is installed (needed for AUR)
sudo pacman -S --needed --noconfirm base-devel

log_success "Repositories configured"
