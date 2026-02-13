#!/bin/bash
# Kusogarch - Preflight Phase
# System checks, hardware detection, repository setup

source "$KUSOGARCH_DIR/install/preflight/show-env.sh"
source "$KUSOGARCH_DIR/install/preflight/trap-errors.sh"
source "$KUSOGARCH_DIR/install/preflight/detect-hardware.sh"
source "$KUSOGARCH_DIR/install/preflight/repositories.sh"
