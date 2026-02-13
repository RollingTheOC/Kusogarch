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

# === Kvantum — Catppuccin Mocha theme ===
# QT_STYLE_OVERRIDE=kvantum forces Kvantum for all Qt apps, including KDE apps
# like Dolphin which bypass qt6ct's palette via their own KDE color management.
mkdir -p "$HOME/.config/Kvantum"
cat > "$HOME/.config/Kvantum/kvantum.kvconfig" << 'EOF'
[General]
theme=Catppuccin-Mocha-Blue
EOF

# === Qt6ct — fallback palette for non-Kvantum contexts ===
mkdir -p "$HOME/.config/qt6ct/colors"

cat > "$HOME/.config/qt6ct/colors/CatppuccinMocha.conf" << 'EOF'
[ColorScheme]
active_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff3b3c50, #ff181825, #ff252536, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff1e1e2e, #ff1e1e2e, #ff11111b, #ff89b4fa, #ff1e1e2e, #ff89b4fa, #ffcba6f7, #ff181825, #ff313244, #ffcdd6f4, #ff6c7086, #ff89b4fa
inactive_colors=#ffcdd6f4, #ff313244, #ff45475a, #ff3b3c50, #ff181825, #ff252536, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff1e1e2e, #ff1e1e2e, #ff11111b, #ff585b70, #ffa6adc8, #ff89b4fa, #ffcba6f7, #ff181825, #ff313244, #ffcdd6f4, #ff6c7086, #ff89b4fa
disabled_colors=#ff6c7086, #ff313244, #ff45475a, #ff3b3c50, #ff181825, #ff252536, #ff6c7086, #ff585b70, #ff6c7086, #ff1e1e2e, #ff1e1e2e, #ff11111b, #ff45475a, #ffa6adc8, #ff585b70, #ff585b70, #ff181825, #ff313244, #ffcdd6f4, #ff45475a, #ff45475a
EOF

cat > "$HOME/.config/qt6ct/qt6ct.conf" << 'EOF'
[Appearance]
color_scheme_path=PLACEHOLDER
custom_palette=true
icon_theme=breeze-dark
standard_dialogs=default
style=kvantum

[Fonts]
fixed="JetBrains Mono Nerd Font,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
general="Noto Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
EOF

sed -i "s|PLACEHOLDER|$HOME/.config/qt6ct/colors/CatppuccinMocha.conf|" "$HOME/.config/qt6ct/qt6ct.conf"

# KDE color scheme (kdeglobals) — KDE apps like Dolphin also read this
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
