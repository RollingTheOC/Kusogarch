#!/bin/bash
# Kusogarch - Bootstrap Script
# Run this from a TTY after a base Arch install
set -eEo pipefail

echo ""
echo "========================================="
echo "  Kusogarch Installer Bootstrap"
echo "  Arch Linux + Hyprland + Surface"
echo "========================================="
echo ""

# Ensure we're running as a regular user (not root)
if [ "$EUID" -eq 0 ]; then
    echo "[ERROR] Do not run this script as root."
    echo "        Run as your regular user (sudo will be used when needed)."
    exit 1
fi

# Ensure sudo is available
if ! command -v sudo &>/dev/null; then
    echo "[ERROR] sudo is required. Install it first:"
    echo "        su -c 'pacman -S sudo && echo \"$USER ALL=(ALL:ALL) ALL\" >> /etc/sudoers'"
    exit 1
fi

# Install git if not present
if ! command -v git &>/dev/null; then
    echo "[INFO] Installing git..."
    sudo pacman -S --needed --noconfirm git
fi

# Configuration
KUSOGARCH_REPO="${KUSOGARCH_REPO:-RollingTheOC/Kusogarch}"
KUSOGARCH_REF="${KUSOGARCH_REF:-main}"
KUSOGARCH_DIR="$HOME/.local/share/kusogarch"

# Clone or update repository
if [ -d "$KUSOGARCH_DIR/.git" ]; then
    echo "[INFO] Updating existing Kusogarch installation..."
    cd "$KUSOGARCH_DIR"
    git fetch origin
    git checkout "$KUSOGARCH_REF"
    git pull origin "$KUSOGARCH_REF"
else
    echo "[INFO] Cloning Kusogarch..."
    rm -rf "$KUSOGARCH_DIR"
    git clone "https://github.com/$KUSOGARCH_REPO.git" "$KUSOGARCH_DIR"
    cd "$KUSOGARCH_DIR"
    git checkout "$KUSOGARCH_REF"
fi

# Make scripts executable
chmod +x "$KUSOGARCH_DIR/install.sh"
chmod +x "$KUSOGARCH_DIR/bin/"*

# Launch installer
echo ""
echo "[INFO] Starting Kusogarch installer..."
echo ""
exec bash "$KUSOGARCH_DIR/install.sh"
