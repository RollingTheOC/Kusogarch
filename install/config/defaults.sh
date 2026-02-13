#!/bin/bash
# Kusogarch - Deploy immutable defaults to ~/.local/share/kusogarch/

log_info "Deploying default configurations..."

DEFAULT_SRC="$KUSOGARCH_DIR/default"
DEFAULT_DST="$HOME/.local/share/kusogarch/defaults"

# The repo lives at ~/.local/share/kusogarch so "default/" is already
# present as a subdirectory. We symlink "defaults" -> "default" so
# Hyprland can find them at the expected path without a redundant copy.
if [ -d "$DEFAULT_SRC" ]; then
    if [ ! -e "$DEFAULT_DST" ]; then
        ln -sf "$DEFAULT_SRC" "$DEFAULT_DST"
        log_step "Symlinked defaults -> default"
    fi
    log_success "Defaults available at $DEFAULT_DST"
else
    log_error "Default config source not found: $DEFAULT_SRC"
    exit 1
fi
