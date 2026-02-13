#!/bin/bash
# Kusogarch - GTK/Qt theming (Catppuccin Mocha)

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

# Qt5/Qt6 - use Kvantum
mkdir -p "$HOME/.config/Kvantum"
cat > "$HOME/.config/Kvantum/kvantum.kvconfig" << 'EOF'
[General]
theme=KvDark
EOF

# KDE color scheme (Catppuccin Mocha) — Dolphin and other KDE apps read this directly
cat > "$HOME/.config/kdeglobals" << 'EOF'
[General]
ColorScheme=CatppuccinMocha
Name=Catppuccin Mocha
font=Noto Sans,11,-1,5,50,0,0,0,0,0
toolBarFont=Noto Sans,10,-1,5,50,0,0,0,0,0

[Colors:View]
BackgroundNormal=30,30,46
BackgroundAlternate=35,35,52
ForegroundNormal=205,214,244
ForegroundInactive=166,173,200
ForegroundLink=137,180,250
ForegroundVisited=203,166,247
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[Colors:Window]
BackgroundNormal=30,30,46
BackgroundAlternate=35,35,52
ForegroundNormal=205,214,244
ForegroundInactive=166,173,200
ForegroundLink=137,180,250
ForegroundVisited=203,166,247
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[Colors:Button]
BackgroundNormal=49,50,68
BackgroundAlternate=69,71,90
ForegroundNormal=205,214,244
ForegroundInactive=166,173,200
ForegroundLink=137,180,250
ForegroundVisited=203,166,247
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[Colors:Selection]
BackgroundNormal=137,180,250
BackgroundAlternate=137,180,250
ForegroundNormal=30,30,46
ForegroundInactive=30,30,46
ForegroundLink=30,30,46
ForegroundVisited=30,30,46
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[Colors:Tooltip]
BackgroundNormal=49,50,68
BackgroundAlternate=49,50,68
ForegroundNormal=205,214,244
ForegroundInactive=166,173,200
ForegroundLink=137,180,250
ForegroundVisited=203,166,247
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[Colors:Complementary]
BackgroundNormal=24,24,37
BackgroundAlternate=30,30,46
ForegroundNormal=205,214,244
ForegroundInactive=166,173,200
ForegroundLink=137,180,250
ForegroundVisited=203,166,247
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[Colors:Header]
BackgroundNormal=24,24,37
BackgroundAlternate=30,30,46
ForegroundNormal=205,214,244
ForegroundInactive=166,173,200
ForegroundLink=137,180,250
ForegroundVisited=203,166,247
ForegroundNegative=243,139,168
ForegroundNeutral=250,179,135
ForegroundPositive=166,227,161
DecorationFocus=137,180,250
DecorationHover=69,71,90

[KDE]
contrast=4
EOF

log_success "GTK/Qt theming configured"
