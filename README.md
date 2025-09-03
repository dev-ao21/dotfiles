# Dotfiles

 [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) compliant dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── home/                    # Files that must be in ~ 
│   ├── .zshrc
│   └── .gitconfig
└── config/                  # XDG-compliant configs
    └── .config/
        ├── zsh/
        ├── vim/
        ├── tmux/
        ├── wezterm/
        ├── fzf/
        └── ,,,
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