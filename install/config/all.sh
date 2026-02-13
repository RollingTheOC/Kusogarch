#!/bin/bash
# Kusogarch - Configuration Phase
# Deploy configs and enable services

source "$KUSOGARCH_DIR/install/config/defaults.sh"
source "$KUSOGARCH_DIR/install/config/dotfiles.sh"
source "$KUSOGARCH_DIR/install/config/shell.sh"
source "$KUSOGARCH_DIR/install/config/network.sh"
source "$KUSOGARCH_DIR/install/config/bluetooth.sh"
source "$KUSOGARCH_DIR/install/config/audio.sh"
source "$KUSOGARCH_DIR/install/config/printing.sh"
source "$KUSOGARCH_DIR/install/config/security.sh"
source "$KUSOGARCH_DIR/install/config/docker.sh"
source "$KUSOGARCH_DIR/install/config/gtk-qt.sh"
source "$KUSOGARCH_DIR/install/config/xdg.sh"

# Surface-specific configuration (conditional)
if [ "$KUSOGARCH_MODE" = "surface" ]; then
    source "$KUSOGARCH_DIR/install/config/surface-config.sh"
    source "$KUSOGARCH_DIR/install/config/surface-power.sh"
fi
