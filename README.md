# Dotfiles

 [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) compliant dotfiles managed with GNU Stow.

## Structure

```
dotfiles/
├── home/                    # Files that must be in ~ 
│   ├── .zshrc
│   ├── .gitconfig
│   └── .p10k.zsh
├── tmux/                    # Individual stow packages
│   └── .config/tmux/
├── fzf/
│   └── .config/fzf/
├── vim/
│   └── .config/vim/
├── wezterm/
│   └── .config/wezterm/
├── zsh/
│   └── .config/zsh/
└── ... (other apps)
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