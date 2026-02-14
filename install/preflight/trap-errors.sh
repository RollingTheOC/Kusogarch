#!/bin/bash
# Kusogarch - Error handling setup

export KUSOGARCH_LOG="/tmp/kusogarch-install.log"
echo "--- Kusogarch install started $(date) ---" > "$KUSOGARCH_LOG"

# Log helper: call this to write a line to the log file
# (stdout stays on the terminal, log file is append-only)
log_to_file() {
    echo "$@" >> "$KUSOGARCH_LOG"
}

# Error trap
on_error() {
    local exit_code=$?
    local line_no=$1
    log_error "Installation failed at line $line_no (exit code: $exit_code)"
    log_error "Check the log at: $KUSOGARCH_LOG"
    log_to_file "FAILED at line $line_no (exit $exit_code)"
    echo ""
    echo "You can resume the installer from where it left off:"
    echo "  bash $KUSOGARCH_DIR/install.sh --resume"
    echo ""
}

trap 'on_error $LINENO' ERR

log_info "Error handling configured"
log_step "Install log: $KUSOGARCH_LOG"

echo ""
echo -e "${YELLOW}${BOLD}  Note: This installation will take a while (10-30+ min depending"
echo -e "  on your internet speed). Packages are being downloaded and"
echo -e "  configured — sit tight and let it run.${NC}"
echo ""
