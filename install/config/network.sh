#!/bin/bash
# Kusogarch - Network configuration

log_info "Configuring networking..."

# Enable NetworkManager
enable_service NetworkManager

# Enable iwd as WiFi backend for NetworkManager
sudo mkdir -p /etc/NetworkManager/conf.d
cat << 'EOF' | sudo tee /etc/NetworkManager/conf.d/wifi-backend.conf >/dev/null
[device]
wifi.backend=iwd
EOF
log_step "Configured iwd as WiFi backend"

# Enable mDNS via avahi
enable_service avahi-daemon

# Configure NSS for mDNS resolution
if ! grep -q "mdns_minimal" /etc/nsswitch.conf; then
    sudo sed -i 's/^hosts:.*/hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns/' /etc/nsswitch.conf
    log_step "Configured mDNS in nsswitch.conf"
fi

log_success "Networking configured"
