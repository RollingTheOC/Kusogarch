#!/bin/bash
# Kusogarch - XDG portal configuration

log_info "Configuring XDG portals..."

# Create user directories
mkdir -p "$HOME"/{Documents,Downloads,Music,Pictures/Screenshots,Videos,Projects}

# === Browser Selection ===
echo ""
BROWSER_CHOICE=$(choose "Select your default web browser:" "Chromium" "Firefox")
case $BROWSER_CHOICE in
    1) BROWSER_DESKTOP="chromium.desktop" ; BROWSER_NAME="Chromium" ;;
    2) BROWSER_DESKTOP="firefox.desktop"  ; BROWSER_NAME="Firefox"  ;;
esac
log_step "Default browser: $BROWSER_NAME"

# File manager: dolphin is installed via base packages
FILEMANAGER_DESKTOP="org.kde.dolphin.desktop"

# Save choices for reference
mkdir -p "$HOME/.config/kusogarch"
echo "$BROWSER_DESKTOP" > "$HOME/.config/kusogarch/browser"
echo "$FILEMANAGER_DESKTOP" > "$HOME/.config/kusogarch/filemanager"

# Set default applications
mkdir -p "$HOME/.config"
cat > "$HOME/.config/mimeapps.list" << EOF
[Default Applications]
text/html=$BROWSER_DESKTOP
x-scheme-handler/http=$BROWSER_DESKTOP
x-scheme-handler/https=$BROWSER_DESKTOP
x-scheme-handler/about=$BROWSER_DESKTOP
x-scheme-handler/unknown=$BROWSER_DESKTOP
text/plain=nvim.desktop
image/png=imv.desktop
image/jpeg=imv.desktop
image/gif=imv.desktop
image/webp=imv.desktop
video/mp4=mpv.desktop
video/webm=mpv.desktop
audio/mpeg=mpv.desktop
audio/flac=mpv.desktop
inode/directory=$FILEMANAGER_DESKTOP
application/pdf=org.gnome.Evince.desktop
EOF

log_success "XDG portals configured"
