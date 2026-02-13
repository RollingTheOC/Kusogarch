#!/bin/bash
# Kusogarch - Shell configuration

log_info "Configuring shell..."

# Add bin directory to PATH in .bashrc
BASHRC="$HOME/.bashrc"

if [ ! -f "$BASHRC" ]; then
    touch "$BASHRC"
fi

# Kusogarch PATH
if ! grep -q "kusogarch" "$BASHRC"; then
    cat >> "$BASHRC" << 'EOF'

# Kusogarch
export KUSOGARCH_DIR="$HOME/.local/share/kusogarch"
export PATH="$KUSOGARCH_DIR/bin:$PATH"
EOF
    log_step "Added Kusogarch to PATH"
fi

# Starship prompt
if ! grep -q "starship" "$BASHRC"; then
    echo 'eval "$(starship init bash)"' >> "$BASHRC"
    log_step "Added Starship prompt"
fi

# Zoxide (smart cd)
if ! grep -q "zoxide" "$BASHRC"; then
    echo 'eval "$(zoxide init bash)"' >> "$BASHRC"
    log_step "Added Zoxide"
fi

# Useful aliases
if ! grep -q "# Kusogarch aliases" "$BASHRC"; then
    cat >> "$BASHRC" << 'EOF'

# Kusogarch aliases
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --icons --level=2'
alias cat='bat --style=auto'
alias grep='rg'
alias find='fd'
alias top='btop'
alias lg='lazygit'
alias ld='lazydocker'
EOF
    log_step "Added shell aliases"
fi

log_success "Shell configured"
