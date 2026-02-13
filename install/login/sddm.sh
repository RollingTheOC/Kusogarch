#!/bin/bash
# Kusogarch - greetd + ReGreet Login Screen
# GTK4 graphical greeter with Catppuccin Mocha theme

log_info "Configuring greetd login..."

# Disable any existing display manager
for dm in sddm gdm lightdm; do
    if systemctl is-enabled "$dm" &>/dev/null; then
        sudo systemctl disable "$dm"
        log_step "Disabled $dm"
    fi
done

# Remove TTY autologin overrides if present (from previous config)
if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
    sudo rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
    sudo rmdir /etc/systemd/system/getty@tty1.service.d 2>/dev/null
    log_step "Removed old TTY autologin override"
fi

# Enable greetd
enable_service greetd

# Determine cage command — add software rendering in VMs
CAGE_CMD="cage -s -- regreet"
IS_VM=false
if command -v systemd-detect-virt &>/dev/null; then
    VM_TYPE=$(systemd-detect-virt --vm 2>/dev/null || true)
    if [ -n "$VM_TYPE" ] && [ "$VM_TYPE" != "none" ]; then
        IS_VM=true
        CAGE_CMD="env WLR_RENDERER_ALLOW_SOFTWARE=1 LIBGL_ALWAYS_SOFTWARE=true cage -s -- regreet"
    fi
fi

# greetd daemon config
sudo mkdir -p /etc/greetd
cat << EOF | sudo tee /etc/greetd/config.toml >/dev/null
[terminal]
vt = 1

[default_session]
command = "$CAGE_CMD"
user = "greeter"
EOF
log_step "greetd config written"

# Find wallpaper for greeter background
GREETER_BG=""
for candidate in \
    "$KUSOGARCH_DIR/themes/default/wallpaper.jpg" \
    "$KUSOGARCH_DIR/themes/default/wallpaper.png" \
    "$KUSOGARCH_DIR/wallpapers"/*.jpg; do
    if [ -f "$candidate" ]; then
        GREETER_BG="$candidate"
        break
    fi
done

# ReGreet config
cat << EOF | sudo tee /etc/greetd/regreet.toml >/dev/null
[background]
path = "${GREETER_BG:-}"
fit = "Cover"

[GTK]
application_prefer_dark_theme = true
cursor_theme_name = "Adwaita"
font_name = "JetBrains Mono Nerd Font 12"
icon_theme_name = "Adwaita"

[commands]
reboot = ["systemctl", "reboot"]
poweroff = ["systemctl", "poweroff"]
EOF
log_step "ReGreet config written"

# ReGreet CSS — Catppuccin Mocha
cat << 'EOF' | sudo tee /etc/greetd/regreet.css >/dev/null
/* Kusogarch - ReGreet Theme (Catppuccin Mocha) */

window {
    background-color: rgba(30, 30, 46, 0.85);
}

box#body {
    margin: 40px;
    padding: 40px;
    border-radius: 16px;
    background-color: rgba(30, 30, 46, 0.95);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

entry {
    background-color: #313244;
    color: #cdd6f4;
    border: 2px solid #45475a;
    border-radius: 8px;
    padding: 10px 14px;
    font-size: 14px;
    min-height: 20px;
}

entry:focus {
    border-color: #89b4fa;
    box-shadow: 0 0 0 2px rgba(137, 180, 250, 0.25);
}

button {
    background-color: #89b4fa;
    color: #1e1e2e;
    border: none;
    border-radius: 8px;
    padding: 10px 20px;
    font-weight: bold;
    font-size: 14px;
    min-height: 20px;
}

button:hover {
    background-color: #b4befe;
}

button:active {
    background-color: #74c7ec;
}

button.destructive {
    background-color: #f38ba8;
}

button.destructive:hover {
    background-color: #eba0ac;
}

combobox button {
    background-color: #313244;
    color: #cdd6f4;
    border: 2px solid #45475a;
}

combobox button:hover {
    border-color: #89b4fa;
}

label {
    color: #cdd6f4;
}

label.error {
    color: #f38ba8;
}

#clock {
    color: #cdd6f4;
    font-size: 48px;
    font-weight: bold;
    margin-bottom: 8px;
}

#date {
    color: #a6adc8;
    font-size: 16px;
    margin-bottom: 24px;
}
EOF
log_step "Catppuccin Mocha CSS applied"

# Give greeter user read access to wallpaper
if [ -n "$GREETER_BG" ]; then
    sudo chmod o+r "$GREETER_BG" 2>/dev/null
fi

# Ensure greeter user can access regreet CSS
if [ -f /etc/greetd/regreet.css ]; then
    # Point regreet to the CSS (add to environment if needed)
    if ! grep -q "css" /etc/greetd/regreet.toml; then
        sudo sed -i '/^\[GTK\]/a css = "/etc/greetd/regreet.css"' /etc/greetd/regreet.toml
    fi
fi

log_success "greetd + ReGreet configured"
