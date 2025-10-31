# Ensure theme structure exists before copying configs
mkdir -p ~/.config/omarchy/current ~/.config/omarchy/themes

# Copy over Omarchy configs
mkdir -p ~/.config
cp -R ~/.local/share/omarchy/config/* ~/.config/

# Use default bashrc from Omarchy
cp ~/.local/share/omarchy/default/bashrc ~/.bashrc
