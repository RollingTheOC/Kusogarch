#!/bin/bash
# Kusogarch - Deploy immutable defaults to ~/.local/share/kusogarch/

log_info "Deploying default configurations..."

DEFAULT_SRC="$KUSOGARCH_DIR/default"
DEFAULT_DST="$HOME/.local/share/kusogarch/defaults"

# If the repo was cloned into ~/.local/share/kusogarch, src and dst
# share the same parent. Use a distinct name ("defaults") to avoid
# copying a directory onto itself.
if [ "$DEFAULT_SRC" = "$DEFAULT_DST" ]; then
    log_info "Repo is already at install location — defaults in place"
else
    mkdir -p "$DEFAULT_DST"
    cp -rf "$DEFAULT_SRC/"* "$DEFAULT_DST/"
    log_success "Defaults deployed to $DEFAULT_DST"
fi
