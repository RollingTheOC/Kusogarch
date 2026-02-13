#!/bin/bash
# Kusogarch - Deploy user config files to ~/.config/

log_info "Deploying configuration files..."

CONFIG_SRC="$KUSOGARCH_DIR/config"
CONFIG_DST="$HOME/.config"

# Create directories
mkdir -p "$CONFIG_DST"/{hypr/bindings,waybar,walker,kitty,mako,btop,fastfetch}
mkdir -p "$CONFIG_DST"/kusogarch/{current,themes}

# Deploy config files (do not overwrite existing user files)
find "$CONFIG_SRC" -type f | while IFS= read -r src; do
    relative="${src#$CONFIG_SRC/}"

    # Skip Surface-specific input config if not in Surface mode
    if [ "$relative" = "hypr/input-surface.conf" ] && [ "$KUSOGARCH_MODE" != "surface" ]; then
        continue
    fi

    copy_no_overwrite "$src" "$CONFIG_DST/$relative"
done

# Set up default theme symlink
THEME_LINK="$CONFIG_DST/kusogarch/current/theme"
if [ ! -L "$THEME_LINK" ]; then
    ln -sf "$KUSOGARCH_DIR/themes/default" "$THEME_LINK"
    echo "default" > "$CONFIG_DST/kusogarch/current/theme.name"
    log_step "Set default theme"
fi

log_success "Configuration files deployed"
