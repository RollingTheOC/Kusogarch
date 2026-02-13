#!/bin/bash
# Kusogarch - Firewall configuration

log_info "Configuring firewall..."

# Enable UFW
enable_service ufw

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow common services
sudo ufw allow ssh

# Enable
sudo ufw --force enable

log_success "Firewall configured (UFW)"
