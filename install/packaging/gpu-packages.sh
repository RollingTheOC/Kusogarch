#!/bin/bash
# Kusogarch - Install GPU-specific drivers

log_info "Configuring GPU drivers for: $KUSOGARCH_GPU"

case $KUSOGARCH_GPU in
    nvidia)
        echo ""
        echo "  Select NVIDIA driver:"
        echo "  1) nvidia (proprietary, latest)"
        echo "  2) nvidia-open (open kernel modules)"
        echo "  3) Skip (use nouveau)"
        echo ""
        read -p "  Choice [1/2/3]: " NVIDIA_CHOICE

        case $NVIDIA_CHOICE in
            1)
                pkg_install nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
                log_success "NVIDIA proprietary drivers installed"
                ;;
            2)
                pkg_install nvidia-open nvidia-utils nvidia-settings
                log_success "NVIDIA open drivers installed"
                ;;
            *)
                log_info "Skipping proprietary NVIDIA drivers (using nouveau)"
                ;;
        esac

        # Wayland-specific NVIDIA environment variables
        mkdir -p "$HOME/.config/hypr"
        cat >> "$HOME/.config/hypr/envs-nvidia.conf" << 'EOF'
# NVIDIA Wayland compatibility
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = NVD_BACKEND,direct
EOF
        log_step "Created NVIDIA environment config for Hyprland"
        ;;

    amd)
        pkg_install mesa vulkan-radeon libva-mesa-driver lib32-mesa
        log_success "AMD GPU drivers installed"
        ;;

    intel)
        # Skip if Surface mode (already handled in surface-packages.sh)
        if [ "$KUSOGARCH_MODE" != "surface" ]; then
            pkg_install mesa vulkan-intel intel-media-driver
            log_success "Intel GPU drivers installed"
        else
            log_info "Intel GPU drivers already included in Surface packages"
        fi
        ;;
esac

# Install CPU microcode
case $KUSOGARCH_CPU in
    intel)
        if [ "$KUSOGARCH_MODE" != "surface" ]; then
            pkg_install intel-ucode
            log_step "Intel microcode installed"
        fi
        ;;
    amd)
        pkg_install amd-ucode
        log_step "AMD microcode installed"
        ;;
esac
