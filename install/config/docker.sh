#!/bin/bash
# Kusogarch - Docker configuration

log_info "Configuring Docker..."

enable_service docker

# Add current user to docker group
sudo usermod -aG docker "$USER"
log_step "Added $USER to docker group"

log_success "Docker configured"
