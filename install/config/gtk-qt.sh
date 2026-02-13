#!/bin/bash
# Kusogarch - GTK/Qt theming

log_info "Configuring GTK/Qt theming..."

# GTK settings
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

# Qt5/Qt6 - use Kvantum
mkdir -p "$HOME/.config/Kvantum"
cat > "$HOME/.config/Kvantum/kvantum.kvconfig" << 'EOF'
[General]
theme=KvArcDark
EOF

log_success "GTK/Qt theming configured"
