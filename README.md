# Dotfiles

[XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) compliant dotfiles managed with GNU Stow.

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
- `cd ~/.config/dotfiles && stow config` - Install app configs
- `cd ~/.config/dotfiles && stow -D config` - Remove apps symlinks

**Backup & Safety:**
- Original configs that are found in `~/.config` are automatically backed up with `.bak` extensions

## XDG Compliance

This setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html):
- Configuration files are stored in `~/.config/`
- Only essential files remain in `~` (shell rc files, gitconfig)
- Apps automatically find configs in XDG locations thanks to environment variables set in `.zshrc`