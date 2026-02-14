#!/bin/bash
# Kusogarch - Installation Summary

echo ""
echo -e "${CYAN}${BOLD}"
cat << 'BANNER'
  _  __                                    _
 | |/ /   _ ___  ___   __ _  __ _ _ __ ___| |__
 | ' / | | / __|/ _ \ / _` |/ _` | '__/ __| '_ \
 | . \ |_| \__ \ (_) | (_| | (_| | | | (__| | | |
 |_|\_\__,_|___/\___/ \__, |\__,_|_|  \___|_| |_|
                       |___/
BANNER
echo -e "${NC}"

echo -e "${GREEN}${BOLD}  Installation Complete!${NC}"
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │  System Configuration                    │"
echo "  ├─────────────────────────────────────────┤"
echo "  │  Mode:       $KUSOGARCH_MODE"
echo "  │  GPU:        $KUSOGARCH_GPU"
if [ "$KUSOGARCH_MODE" = "surface" ]; then
echo "  │  Kernel:     linux-surface"
echo "  │  Touch:      iptsd enabled"
fi
echo "  │  Compositor: Hyprland"
echo "  │  Terminal:   Kitty"
echo "  │  Bar:        Waybar"
echo "  │  Launcher:   Walker"
INSTALLED_THEME=$(cat "$HOME/.config/kusogarch/current/theme.name" 2>/dev/null || echo "default")
echo "  │  Theme:      $INSTALLED_THEME"
INSTALLED_BROWSER=$(cat "$HOME/.config/kusogarch/browser" 2>/dev/null || echo "chromium.desktop")
echo "  │  Browser:    ${INSTALLED_BROWSER%.desktop}"
echo "  │  Files:      Dolphin"
echo "  └─────────────────────────────────────────┘"
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │  Quick Reference                         │"
echo "  ├─────────────────────────────────────────┤"
echo "  │  Super+Space       App Launcher          │"
echo "  │  Super+Return      Terminal              │"
echo "  │  Super+W           Close Window          │"
echo "  │  Super+1-0         Workspaces            │"
echo "  │  Super+F           Fullscreen            │"
echo "  │  Super+B           Browser               │"
echo "  │  Super+N           Neovim                │"
echo "  │  Super+E           File Manager          │"
echo "  │  Super+K           All Keybindings       │"
echo "  │  Super+Alt+Space   Control Menu          │"
echo "  │  Super+Ctrl+L      Lock Screen           │"
echo "  │  Super+Escape      Power Menu            │"
echo "  └─────────────────────────────────────────┘"
echo ""
echo "  Log saved to: /tmp/kusogarch-install.log"
echo ""
