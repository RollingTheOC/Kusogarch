# Set links for Nautilius action icons
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg

# Setup theme links
mkdir -p ~/.config/omarchy/themes
for f in ~/.local/share/omarchy/themes/*; do ln -nfs "$f" ~/.config/omarchy/themes/; done

# Set initial theme
mkdir -p ~/.config/omarchy/current
ln -snf ~/.config/omarchy/themes/shadesofjade ~/.config/omarchy/current/theme

# Ensure theme hyprland.conf exists (create empty one if theme doesn't have it)
if [[ ! -f ~/.config/omarchy/current/theme/hyprland.conf ]]; then
  echo "# Placeholder theme config" > ~/.config/omarchy/current/theme/hyprland.conf
fi
ln -snf ~/.config/omarchy/current/theme/backgrounds/Dark-Curves-by-Pawel-Czerwinski-Z18Pro.jpg ~/.config/omarchy/current/background

# Set specific app links for current theme
# ~/.config/omarchy/current/theme/neovim.lua -> ~/.config/nvim/lua/plugins/theme.lua is handled via omarchy-setup-nvim

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/omarchy/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config

mkdir -p ~/.config/eza
ln -snf ~/.config/omarchy/current/theme/eza.yml ~/.config/eza/theme.yml

# Add managed policy directories for Chromium and Brave for theme changes
sudo mkdir -p /etc/chromium/policies/managed
sudo chmod a+rw /etc/chromium/policies/managed

sudo mkdir -p /etc/brave/policies/managed
sudo chmod a+rw /etc/brave/policies/managed
