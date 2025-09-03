#!/bin/bash

set -e

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
echo "🎉 Setup complete!"
echo "More configuration steps will be added soon..."