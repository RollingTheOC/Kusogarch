#!/bin/bash
# Kusogarch - GTK/Qt theming setup

log_info "Configuring GTK/Qt theming..."

# GTK3 settings
mkdir -p "$HOME/.config/gtk-3.0"
cat > "$HOME/.config/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-cursor-theme-name=default
gtk-cursor-theme-size=24
gtk-font-name=Noto Sans 11
gtk-application-prefer-dark-theme=true
EOF

# GTK4
mkdir -p "$HOME/.config/gtk-4.0"
cat > "$HOME/.config/gtk-4.0/settings.ini" << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-cursor-theme-name=default
gtk-cursor-theme-size=24
gtk-font-name=Noto Sans 11
gtk-application-prefer-dark-theme=true
EOF

# Set gsettings if available
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
fi

# === KDE color scheme (kdeglobals) — fallback for KDE apps ===
# hyprqt6engine is the primary color source (via .colors file).
# kdeglobals is initialized from the default theme's qt.colors and
# updated on theme switch by kusogarch-theme-set.
DEFAULT_QT_COLORS="$KUSOGARCH_DIR/themes/default/qt.colors"
if [ -f "$DEFAULT_QT_COLORS" ]; then
    cp "$DEFAULT_QT_COLORS" "$HOME/.config/kdeglobals"
fi

log_success "GTK/Qt theming configured"
