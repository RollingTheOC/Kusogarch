#!/bin/bash
# Kusogarch - Login Phase
# Display manager and boot configuration

source "$KUSOGARCH_DIR/install/login/sddm.sh"
source "$KUSOGARCH_DIR/install/login/plymouth.sh"

if [ "$KUSOGARCH_MODE" = "surface" ]; then
    source "$KUSOGARCH_DIR/install/login/bootloader-surface.sh"
fi
