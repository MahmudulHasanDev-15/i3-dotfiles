# i3 Dotfiles
> My personal Arch Linux dotfiles with i3 window manager

## System Info
| Component | Package |
|-----------|---------|
| OS | Arch Linux |
| WM | i3 |
| Terminal | Wezterm |
| Shell | Zsh + Oh My Zsh |
| Editor | Neovim |
| Bar | Polybar |
| Launcher | Rofi |
| Compositor | Picom |
| File Manager | Nemo + Yazi |
| Theme | Catppuccin Mocha |
| Icons | Papirus |
| Cursor | Catppuccin Mocha |
| Font | JetBrains Mono Nerd |
| Display Manager | SDDM |

## Installation

### Requirements
- Fresh Arch Linux install
- Internet connection
- Git

### Install
```bash
sudo pacman -S git base-devel
git clone https://github.com/MahmudulHasanDev-15/i3-dotfiles.git
cd i3-dotfiles
chmod +x install.sh
./install.sh
```

## What install.sh does
1. Updates system
2. Installs all packages from pkglist.txt and aurlist.txt
3. Installs GPU driver of your choice
4. Configures Git
5. Installs Oh My Zsh + plugins
6. Installs Tmux plugins
7. Copies all config files
8. Changes shell to Zsh
9. Enables all required services
10. Reboots

## License
MIT License — see [LICENSE](LICENSE) for details
