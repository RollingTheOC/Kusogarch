#!/bin/bash
# Kusogarch - Deploy user config files to ~/.config/

log_info "Deploying configuration files..."

CONFIG_SRC="$KUSOGARCH_DIR/config"
CONFIG_DST="$HOME/.config"

# Create directories
mkdir -p "$CONFIG_DST"/{hypr/bindings,waybar,walker,kitty,mako,btop,fastfetch}
mkdir -p "$CONFIG_DST"/kusogarch/{current,themes}

# Deploy config files (do not overwrite existing user files)
while IFS= read -r -d '' src; do
    relative="${src#$CONFIG_SRC/}"
    copy_no_overwrite "$src" "$CONFIG_DST/$relative"
done < <(find "$CONFIG_SRC" -type f -print0)

# input-surface.conf: Hyprland always sources this file, so it MUST exist.
# In Desktop mode, create an empty placeholder so Hyprland doesn't crash.
SURFACE_INPUT="$CONFIG_DST/hypr/input-surface.conf"
if [ ! -f "$SURFACE_INPUT" ]; then
    echo "# No Surface input config (desktop mode)" > "$SURFACE_INPUT"
    log_step "Created empty input-surface.conf placeholder"
fi

# Set up default theme symlink (remove broken symlinks first)
THEME_LINK="$CONFIG_DST/kusogarch/current/theme"
if [ -L "$THEME_LINK" ] && [ ! -e "$THEME_LINK" ]; then
    rm -f "$THEME_LINK"
    log_step "Removed broken theme symlink"
fi

if [ ! -L "$THEME_LINK" ] && [ ! -d "$THEME_LINK" ]; then
    ln -sf "$KUSOGARCH_DIR/themes/default" "$THEME_LINK"
    echo "default" > "$CONFIG_DST/kusogarch/current/theme.name"
    log_step "Set default theme"
fi

# Verify theme symlink target exists
if [ -L "$THEME_LINK" ] && [ ! -e "$THEME_LINK" ]; then
    log_warn "Theme symlink broken, resetting to default"
    rm -f "$THEME_LINK"
    ln -sf "$KUSOGARCH_DIR/themes/default" "$THEME_LINK"
    echo "default" > "$CONFIG_DST/kusogarch/current/theme.name"
fi

log_success "Configuration files deployed"
