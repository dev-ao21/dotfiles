#!/bin/bash

set -e

# Configuration arrays for easy management
# HOME_FILES: Files that will be symlinked to the home directory
# CONFIG_APPS: Apps that will be symlinked to ~/.config/
HOME_FILES=(.zshrc .gitconfig .p10k.zsh)
CONFIG_APPS=(tmux fzf vim wezterm iterm2 rectangle zsh brew)

echo "🔧 Dotfiles Setup Script"
echo "========================="
echo

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed."
    echo
    echo "Homebrew is required to install the packages defined in this dotfiles setup."
    echo "You can install it by running:"
    echo
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo
    read -p "Would you like to install Homebrew now? (y/n/q): " -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for the rest of this script
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    elif [[ $REPLY =~ ^[Qq]$ ]]; then
        echo "👋 Setup cancelled by user"
        exit 0
    else
        echo "⚠️  Setup cancelled. Please install Homebrew manually and run this script again."
        exit 1
    fi
else
    echo "✅ Homebrew is already installed"
fi

echo
echo "📋 The following packages will be installed from Brewfile:"
echo "--------------------------------------------------------"
cat brew/Brewfile | grep -E '^(brew|cask)' | sed 's/^/  /'
echo

read -p "Do you want to install these packages? (y/n/q): " -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing packages..."
    cd brew
    brew bundle install
    cd ..
    echo "✅ Package installation complete"
elif [[ $REPLY =~ ^[Qq]$ ]]; then
    echo "👋 Setup cancelled by user"
    exit 0
else
    echo "⏭️  Skipping package installation"
fi

echo
echo "🖥️  macOS shows accent character popup when holding keys (bad for vim navigation with hjkl)."
read -p "Do you want to disable the accent popup for better vim experience? (y/n/q): " -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ -f "vim/disable-mac-hold-key.sh" ]]; then
        chmod +x vim/disable-mac-hold-key.sh
        ./vim/disable-mac-hold-key.sh
        echo "✅ Vim macOS configuration complete"
    else
        echo "⚠️  vim/disable-mac-hold-key.sh not found, skipping"
    fi
elif [[ $REPLY =~ ^[Qq]$ ]]; then
    echo "👋 Setup cancelled by user"
    exit 0
else
    echo "⏭️  Skipping vim macOS configuration"
fi

echo
echo "📦 Backing up existing configurations..."

# Backup .config directories
for app in "${CONFIG_APPS[@]}"; do
    if [ -d "$HOME/.config/$app" ]; then
        echo "  Backing up ~/.config/$app → ~/.config/${app}.bak"
        mv "$HOME/.config/$app" "$HOME/.config/${app}.bak"
    fi
done

echo
echo "🔗 Installing dotfiles with stow..."
if command -v stow &> /dev/null; then
    echo "  Creating symlinks for dotfiles..."
    
    stow -t ~/.config config
    
    echo "✅ All dotfiles installed!"
    
    # Configure .zshrc to source our dotfiles
    echo "🔧 Configuring ~/.zshrc..."
    ZSHRC_CONTENT=$(cat <<'EOF'
# Shared dotfiles configuration
source ~/.config/zsh/zshrc_base

############################
# Local machine-specific configuration below

EOF
)
    
    if [[ -f "$HOME/.zshrc" ]]; then
        # Check if our source line is already present
        if ! grep -q "source ~/.config/zsh/zshrc_base" "$HOME/.zshrc"; then
            echo "  Backing up existing ~/.zshrc to ~/.zshrc.bak"
            cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
            
            # Create new .zshrc with our header and existing content
            echo "$ZSHRC_CONTENT" > "$HOME/.zshrc.new"
            
            # Append existing content, skipping any duplicate source lines
            grep -v "source ~/.config/zsh/zshrc_base" "$HOME/.zshrc.bak" >> "$HOME/.zshrc.new"
            
            mv "$HOME/.zshrc.new" "$HOME/.zshrc"
            echo "  ✅ Updated ~/.zshrc (original backed up)"
        else
            echo "  ✅ ~/.zshrc already configured correctly"
        fi
    else
        echo "$ZSHRC_CONTENT" > "$HOME/.zshrc"
        echo "  ✅ Created ~/.zshrc"
    fi
    
    # Source tmux config if tmux is running
    echo "🔄 Reloading tmux configuration..."
    if command -v tmux &> /dev/null && tmux list-sessions &> /dev/null; then
        tmux source-file ~/.config/tmux/tmux.conf
        echo "✅ Tmux configuration reloaded!"
    else
        echo "ℹ️  Tmux not running - config will load on next tmux session"
    fi
else
    echo "⚠️  GNU Stow not found. Install with: brew install stow"
    echo "Then run the individual stow commands or run this script again"
fi

echo
echo "🎉 Setup complete!"
echo "Your original configurations have been backed up with .bak extensions"