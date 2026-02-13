#!/bin/bash
# Kusogarch - Error handling setup

KUSOGARCH_LOG="/tmp/kusogarch-install.log"

# Log all output to file as well
exec > >(tee -a "$KUSOGARCH_LOG") 2>&1

# Error trap
on_error() {
    local exit_code=$?
    local line_no=$1
    log_error "Installation failed at line $line_no (exit code: $exit_code)"
    log_error "Check the log at: $KUSOGARCH_LOG"
    echo ""
    echo "You can re-run the installer after fixing the issue:"
    echo "  bash $KUSOGARCH_DIR/install.sh"
    echo ""
}

trap 'on_error $LINENO' ERR

log_info "Error handling configured"
log_step "Install log: $KUSOGARCH_LOG"
