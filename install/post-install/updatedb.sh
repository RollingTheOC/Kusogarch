#!/bin/bash
# Kusogarch - Refresh file locate database

log_info "Updating file locate database..."

sudo updatedb 2>/dev/null || true

log_success "Locate database updated"
