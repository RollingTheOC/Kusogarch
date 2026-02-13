#!/bin/bash
# Kusogarch - Hardware detection and mode selection

log_info "Detecting hardware..."

# Auto-detect Microsoft Surface via DMI
IS_SURFACE=false
SURFACE_MODEL=""
if [ -f /sys/devices/virtual/dmi/id/product_name ]; then
    PRODUCT_NAME=$(cat /sys/devices/virtual/dmi/id/product_name)
    if echo "$PRODUCT_NAME" | grep -qi "surface"; then
        IS_SURFACE=true
        SURFACE_MODEL="$PRODUCT_NAME"
        log_step "Detected Microsoft $SURFACE_MODEL"
    fi
fi

# Detect GPU vendor
GPU_TYPE="intel" # default fallback
if lspci 2>/dev/null | grep -qi "nvidia"; then
    GPU_TYPE="nvidia"
    log_step "GPU: NVIDIA detected"
elif lspci 2>/dev/null | grep -qi "amd\|radeon"; then
    GPU_TYPE="amd"
    log_step "GPU: AMD detected"
else
    log_step "GPU: Intel (or unknown, defaulting to Intel)"
fi

# Detect CPU vendor
CPU_VENDOR="unknown"
if grep -qi "intel" /proc/cpuinfo 2>/dev/null; then
    CPU_VENDOR="intel"
elif grep -qi "amd" /proc/cpuinfo 2>/dev/null; then
    CPU_VENDOR="amd"
fi
log_step "CPU: $CPU_VENDOR"

# Present hardware mode selection
echo ""
echo -e "${BOLD}=========================================${NC}"
echo -e "${BOLD}  Hardware Profile Selection${NC}"
echo -e "${BOLD}=========================================${NC}"
echo ""
echo "  1) Desktop Mode  - Standard linux kernel, generic hardware"
echo "  2) Surface Mode   - linux-surface kernel, touch/pen/camera support"
echo ""

if [ "$IS_SURFACE" = true ]; then
    echo -e "  ${GREEN}[Surface hardware detected: $SURFACE_MODEL]${NC}"
    echo -e "  ${GREEN}Recommended: Surface Mode${NC}"
    echo ""
fi

read -p "  Select mode [1/2]: " HARDWARE_MODE

case $HARDWARE_MODE in
    2)
        export KUSOGARCH_MODE="surface"
        log_success "Surface mode selected"
        ;;
    *)
        export KUSOGARCH_MODE="desktop"
        log_success "Desktop mode selected"
        ;;
esac

export KUSOGARCH_GPU="$GPU_TYPE"
export KUSOGARCH_CPU="$CPU_VENDOR"
export KUSOGARCH_IS_SURFACE="$IS_SURFACE"

# Save mode to file for post-install reference
mkdir -p "$HOME/.config/kusogarch"
echo "$KUSOGARCH_MODE" > "$HOME/.config/kusogarch/mode"
echo "$KUSOGARCH_GPU" > "$HOME/.config/kusogarch/gpu"
