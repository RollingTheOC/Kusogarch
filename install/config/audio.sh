#!/bin/bash
# Kusogarch - Audio configuration (PipeWire)

log_info "Configuring audio..."

# PipeWire services are user services, enable them
enable_user_service pipewire
enable_user_service pipewire-pulse
enable_user_service wireplumber

log_success "Audio configured (PipeWire)"
