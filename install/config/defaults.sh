#!/bin/bash
# Kusogarch - Deploy immutable defaults to ~/.local/share/kusogarch/

log_info "Deploying default configurations..."

DEFAULT_SRC="$KUSOGARCH_DIR/default"
DEFAULT_DST="$HOME/.local/share/kusogarch/default"

mkdir -p "$DEFAULT_DST"

# Always overwrite defaults (they're immutable system files)
cp -rf "$DEFAULT_SRC/"* "$DEFAULT_DST/"

log_success "Defaults deployed to $DEFAULT_DST"
