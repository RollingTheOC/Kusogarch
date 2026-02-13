#!/bin/bash
# Kusogarch - XDG portal configuration

log_info "Configuring XDG portals..."

# Create user directories
mkdir -p "$HOME"/{Documents,Downloads,Music,Pictures/Screenshots,Videos,Projects}

# Set default applications
mkdir -p "$HOME/.config"
cat > "$HOME/.config/mimeapps.list" << 'EOF'
[Default Applications]
text/html=chromium.desktop
x-scheme-handler/http=chromium.desktop
x-scheme-handler/https=chromium.desktop
x-scheme-handler/about=chromium.desktop
x-scheme-handler/unknown=chromium.desktop
text/plain=nvim.desktop
image/png=imv.desktop
image/jpeg=imv.desktop
image/gif=imv.desktop
image/webp=imv.desktop
video/mp4=mpv.desktop
video/webm=mpv.desktop
audio/mpeg=mpv.desktop
audio/flac=mpv.desktop
inode/directory=org.gnome.Nautilus.desktop
application/pdf=org.gnome.Evince.desktop
EOF

log_success "XDG portals configured"
