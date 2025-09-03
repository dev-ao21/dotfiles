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
│   └── tmux.conf
├── fzf/
│   └── default-opts.conf
├── vim/
│   ├── vimrc
│   └── disable-mac-hold-key.sh
├── wezterm/
│   └── wezterm.lua
├── zsh/
│   └── aliases
└── ...

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

## Manual Stow Commands

If you need to manage dotfiles manually:
- `stow -t $HOME home` - Install home directory files
- `stow -t ~/.config config` - Install app configs
- `stow -t $HOME home` - Remove home directory symlinks
- `stow -D -t ~/.config config` - Remove apps symlinks

**Backup & Safety:**
- Original configs are automatically backed up with `.bak` extensions
- To restore: `mv ~/.zshrc.bak ~/.zshrc` (example)

## XDG Compliance

This setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html):
- Configuration files are stored in `~/.config/`
- Only essential files remain in `~` (shell rc files, gitconfig)
- Apps automatically find configs in XDG locations thanks to environment variables set in `.zshrc`