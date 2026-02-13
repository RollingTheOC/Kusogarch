#!/bin/bash
# Kusogarch - Ensure fonts are properly configured

log_info "Configuring fonts..."

# Fonts are already in the base packages list, just refresh the font cache
fc-cache -fv &>/dev/null

log_success "Font cache updated"
