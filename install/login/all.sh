#!/bin/bash
# Kusogarch - Login Phase
# TTY autologin and boot configuration

source "$KUSOGARCH_DIR/install/login/sddm.sh"
source "$KUSOGARCH_DIR/install/login/plymouth.sh"

if [ "$KUSOGARCH_MODE" = "surface" ]; then
    source "$KUSOGARCH_DIR/install/login/bootloader-surface.sh"
fi
