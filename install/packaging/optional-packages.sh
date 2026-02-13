#!/bin/bash
# Kusogarch - Interactive optional package selection

log_info "Optional packages"
echo ""
echo "  Select additional packages to install (optional)."
echo "  Use TAB to select, ENTER to confirm, ESC to skip."
echo ""

# Check if fzf is available (should be by now)
if ! cmd_exists fzf; then
    log_warn "fzf not available, skipping optional package selection"
    return 0
fi

OPTIONAL_LIST="$KUSOGARCH_DIR/install/kusogarch-optional.packages"
PACKAGES=$(grep -v '^#' "$OPTIONAL_LIST" | grep -v '^\s*$')

if [ -z "$PACKAGES" ]; then
    log_info "No optional packages defined"
    return 0
fi

SELECTED=$(echo "$PACKAGES" | \
    fzf --multi \
        --prompt="Optional packages > " \
        --header="TAB to select | ENTER to install | ESC to skip all" \
        --preview='pacman -Sii {1} 2>/dev/null || yay -Sii {1} 2>/dev/null || echo "Package info unavailable"' \
        --preview-window='right:50%:wrap' \
        --layout=reverse \
        --border=rounded \
        --height=80% \
    || true  # Don't fail if user presses ESC
)

if [ -n "$SELECTED" ]; then
    log_info "Installing selected optional packages..."
    for pkg in $SELECTED; do
        if pacman -Sii "$pkg" &>/dev/null; then
            pkg_install "$pkg"
        else
            aur_install "$pkg"
        fi
    done
    log_success "Optional packages installed"
else
    log_info "No optional packages selected"
fi
