# Dotfiles

My personal configs managed as [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) compliant dotfiles.

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/dev-ao21/dotfiles.git ~/.config/dotfiles && cd ~/.config/dotfiles
   ```

2. Run the setup script (installs brew packages and symlinks dotfiles):
   ```bash
   ./setup.sh
   ```

## Manual Stow Commands

- `cd ~/.config/dotfiles && stow config` - Install symlinks
- `cd ~/.config/dotfiles && stow -D config` - Remove symlinks

**Backup & Safety:**
- Original configs that are found in `~/.config` are automatically backed up with `.bak` extensions