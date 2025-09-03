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
cat brew/.config/brew/Brewfile | grep -E '^(brew|cask)' | sed 's/^/  /'
echo

read -p "Do you want to install these packages? (y/n/q): " -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing packages..."
    cd brew/.config/brew
    brew bundle install
    cd ../../..
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

# Backup home directory files
for file in "${HOME_FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "  Backing up ~/$file → ~/${file}.bak"
        mv "$HOME/$file" "$HOME/${file}.bak"
    fi
done

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
    
    # Stow home directory files
    stow -v home
    
    # Stow each app configuration to ~/.config
    for app in "${CONFIG_APPS[@]}"; do
        echo "  Linking $app configuration..."
        stow -v -t ~/.config $app
    done
    
    echo "✅ All dotfiles installed!"
    
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