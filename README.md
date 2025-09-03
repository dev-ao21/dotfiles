# Dotfiles

XDG Base Directory compliant dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── home/                    # Files that must be in ~ 
│   ├── .zshrc
│   └── .gitconfig
└── config/                  # XDG-compliant configs
    └── .config/
        ├── brew/
        ├── zsh/
        ├── vim/
        ├── tmux/
        ├── wezterm/
        ├── fzf/
        ├── iterm2/
        └── rectangle/
```

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/dev-ao21/dotfiles.git ~/.config/dotfiles
   cd ~/.config/dotfiles
   ```

2. Run the setup script (installs packages and symlinks dotfiles):
   ```bash
   ./setup.sh
   ```

## XDG Compliance

This setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html):
- Configuration files are stored in `~/.config/`
- Only essential files remain in `~` (shell rc files, gitconfig)
- Apps automatically find configs in XDG locations