#!/usr/bin/env bash
#
# Automated dotfiles installer
#
# Author: MahmudulHasanDev-15
# License: MIT

export scriptVersion="1.5"

### COLOR CODES ###
export red="\e[1;31m"
export green="\e[1;32m"
export yellow="\e[1;33m"
export cyan="\e[1;36m"
export reset="\e[0m"

### FUNCTIONS ###
confirmInstallation() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  i3 Dotfiles                                     │
│  By MahmudulHasanDev-15                          │
│                                                  │
│  Installer Version 1.5                           │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    while true; do
        read -rp "Continue installation? [Y/n] " confirm
        case "${confirm}" in
        [Nn])
            exitScript "Aborted!"
            ;;
        *)
            echo -e "Installing..."
            break
            ;;
        esac
    done
}

updateSystem() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Updating System...                              │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    sudo pacman -Syyu --noconfirm
}

checkAurHelper() {
    if ! command -v paru >/dev/null 2>&1; then
        installAurHelper
    fi
}

installAurHelper() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Installing Paru...                              │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    cd "/tmp" || exit 1
    git clone https://aur.archlinux.org/paru.git
    cd paru || exit 1
    rustup default stable
    makepkg -si --noconfirm
    cd "${directory}" || exit 1
}

installPackages() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Installing Packages...                          │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    # Official packages
    sed '/^\s*#/d;/^\s*$/d' "${directory}/pkglist.txt" \
      | sudo pacman -S --needed --noconfirm -

    # AUR packages
    checkAurHelper
    sed '/^\s*#/d;/^\s*$/d' "${directory}/aurlist.txt" \
      | paru -S --needed --noconfirm -

    # Pipewire group
    sudo usermod -a -G rtkit "${USER}"
}

chooseGpuDriver() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Choose GPU Driver                               │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    echo -e "┌─────────────────────────────────────────────────────┐"
    echo -e "│ 1: Intel  -> vulkan-intel    (Recommended)          │"
    echo -e "├─────────────────────────────────────────────────────┤"
    echo -e "│ 2: AMD    -> vulkan-radeon   (Recommended)          │"
    echo -e "├─────────────────────────────────────────────────────┤"
    echo -e "│ 3: Nvidia -> nvidia-utils    (Proprietary)          │"
    echo -e "│ 3: Nvidia -> vulkan-nouveau  (Open-Source)          │"
    echo -e "├─────────────────────────────────────────────────────┤"
    echo -e "│ 4: Skip   (already installed)                       │"
    echo -e "└─────────────────────────────────────────────────────┘"
    echo -e ""

    while true; do
        read -rp "Your Choice: " choice
        case "${choice}" in
        "1" | "intel" | "Intel")
            echo -e "Installing Intel driver..."
            sudo pacman -S --needed --noconfirm vulkan-intel intel-media-driver libva-intel-driver
            break
            ;;
        "2" | "amd" | "AMD")
            echo -e "Installing AMD driver..."
            sudo pacman -S --needed --noconfirm vulkan-radeon
            break
            ;;
        "3" | "nvidia" | "Nvidia")
            echo -e ""
            echo -e "┌─────────────────────────────────────────────────────┐"
            echo -e "│ 1: nvidia-utils   (Proprietary) (Recommended)       │"
            echo -e "│ 2: vulkan-nouveau (Open-Source)  (Slower)           │"
            echo -e "└─────────────────────────────────────────────────────┘"
            echo -e ""
            read -rp "Your Choice: " nvchoice
            case "${nvchoice}" in
            "1")
                sudo pacman -S --needed --noconfirm nvidia-utils
                ;;
            "2")
                sudo pacman -S --needed --noconfirm vulkan-nouveau
                ;;
            esac
            break
            ;;
        "4" | "skip" | "Skip")
            echo -e "Skipping..."
            break
            ;;
        *)
            echo -e "Invalid Answer"
            continue
            ;;
        esac
    done
}

chooseExtras() {
    clear
    cat <<"EOF"


┌──────────────────────────────────────────────────┐
│                                                  │
│ Choose input settings                            │
│                                                  │
└──────────────────────────────────────────────────┘

EOF

        while true; do
                read -rp "Please choose your keyboard layout ('us' or 'de' for Desktop, 'de-latin1' for Laptops): " layout
                if sudo localectl set-keymap "${layout}"; then
                        break
                else
                        echo -e "${layout} is not a valid keyboard layout"
                fi
        done
        echo -e ""

        echo -e "┌───────────────────────────────────────────┐"
        echo -e "│ Please choose your preffered input driver │"
        echo -e "├───────────────────────┬───────────────────┴───────────────────────────────────────┐"
        echo -e "│ 1: libinput (Default) │ Best hardware support, variable sensitivity, High Latency │"
        echo -e "├───────────────────────┼───────────────────────────────────────────────────────────┤"
        echo -e "│ 2: xf86-input-evdev   │ Lowest Latency, limited support, no sensitivity setting   │"
        echo -e "└───────────────────────┴───────────────────────────────────────────────────────────┘"
        echo -e ""
        while true; do
                read -rp "Your Choice: " choice

                case "${choice}" in
                "1" | "libinput" | "Libinput" | "default" | "Default")
                        echo -e "You chose libinput"
                        break
                        ;;
                "2" | "xf86-input-evdev" | "xf86" | "evdev")
                        echo -e "You chose xf86-input-evdev"
                        mkdir -p "${HOME}/.config"
                        sudo mv "/usr/share/X11/xorg.conf.d/40-libinput.conf" "${HOME}/.config/"
                        sudo cp -r "${directory}/assets/xf86-input-evdev/50-mouse-acceleration.conf" "/etc/X11/xorg.conf.d/"
                        break
                        ;;
                *)
                        echo -e "Invalid Answer"
                        continue
                        ;;
                esac
        done







cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│ Choose extra settings                            │
│                                                  │
└──────────────────────────────────────────────────┘

EOF

        while true; do
                read -rp "Add a Wifi Menu to the top bar? (Recommended for Laptops) [y/N] " option
                case "${option}" in
                [Yy])
                        echo -e "Adding Wifi Menu..."
                        sudo pacman -S --needed --noconfirm network-manager-applet
                        break
                        ;;
                *)
                        echo -e "Skipping..."
                        break
                        ;;
                esac
        done
        echo -e ""

        while true; do
                read -rp "Add Bluetooth support? [y/N] " option
                case "${option}" in
                [Yy])
                        echo -e "Adding Bluetooth Menu..."
                       sudo pacman -S --needed --noconfirm bluez bluez-utils blueman
                        sudo systemctl enable bluetooth.service
                        break
                        ;;
                *)
                       echo -e "Skipping..."
                        break
                        ;;
                esac
        done
        echo -e ""

        while true; do
                read -rp "Set CPU Governor to performance? (does not work in VMs) [y/N] " option
                case "${option}" in
                [Yy])
                        echo -e "Setting CPU Governor to performance..."
                        sudo pacman -S --needed --noconfirm cpupower
                        echo "governor='performance'" | sudo tee "/etc/default/cpupower"
                        sudo systemctl enable cpupower --now
                        break
                        ;;
                *)
                        echo -e "Skipping..."
                        break
                        ;;
                esac
        done
        echo -e ""
}



configureGit() {
    clear
    cat <<"EOF"

┌──────────────────────────────────────────────────┐
│                                                  │
│  Configure Git                                   │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    read -rp "Enter your git username: " gitname
    read -rp "Enter your git email: " gitemail

    git config --global user.name "${gitname}"
    git config --global user.email "${gitemail}"
    git config --global core.editor nvim
    git config --global init.defaultBranch main

    echo -e "${green}Git configured successfully!${reset}"
}

installOhMyZsh() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Installing Oh My Zsh...                         │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo -e "${green}Oh My Zsh already is installed, skipping...${reset}"
    fi

    # Zsh plugins
    echo -e "\nInstalling zsh plugins..."

    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
          "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    else
        echo -e "${green}zsh-autosuggestions is already installed, skipping...${reset}"
    fi

    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting \
          "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    else
        echo -e "${green}zsh-syntax-highlighting is already installed, skipping...${reset}"
    fi

    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/" ]; then
        git clone https://github.com/romkatv/powerlevel10k \
            "$HOME/.oh-my-zsh/themes/powerlevel10k"
    else echo "${green}powerlevel10k is already installed, skipping...${reset}"
    fi
}

installTmuxPlugins() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Installing Tmux Plugins...                      │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm \
          "$HOME/.tmux/plugins/tpm"
        "$HOME/.tmux/plugins/tpm/bin/install_plugins"
    else
        echo -e "${green}TPM already installed, skipping...${reset}"
    fi
}

copyFiles() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Copying Files...                                │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    mkdir -p "${HOME}/.config"

    # Permissions
    chmod +x "${directory}/.config/polybar/launch.sh"
    chmod +x "${directory}/.config/polybar/tray.sh"
    chmod +x "${directory}/.config/rofi/scripts/"*
    chmod +x "${directory}/.fehbg"

    # Config files
    cp -r "${directory}/.config/"* "${HOME}/.config/"
    cp "${directory}/.zshrc"       "${HOME}/.zshrc"
    cp "${directory}/.zsh_history" "${HOME}/.zsh_history"
    cp "${directory}/.tmux.conf"   "${HOME}/.tmux.conf"
    cp "${directory}/.wezterm.lua" "${HOME}/.wezterm.lua"
    cp "${directory}/.fehbg"       "${HOME}/.fehbg"
    cp "${directory}/.p10k.zsh"    "${HOME}/.p10k.zsh"
    cp "${directory}/zsh-themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" "${HOME}/.oh-my-zsh/custom/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"
    # SDDM config
    sudo cp "${directory}/sddm/sddm.conf" "/etc/sddm.conf"
}

changeShell() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Changing Shell to Zsh...                        │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    chsh -s "$(which zsh)"
}

enableServices() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Enabling Services...                            │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    sudo systemctl enable NetworkManager
    sudo systemctl enable systemd-timesyncd --now
    sudo systemctl enable sddm
    sudo systemctl enable fstrim.timer
    systemctl --user enable pipewire pipewire-pulse wireplumber
}

finished() {
    clear
    cat <<"EOF"
┌──────────────────────────────────────────────────┐
│                                                  │
│  Installation Finished!                          │
│                                                  │
└──────────────────────────────────────────────────┘

EOF
    echo -e "Rebooting in..."
    for i in {5..1}; do
        echo -e "$i"
        sleep 1
    done
    echo -e "Rebooting now!"
    sudo reboot now
}

errorHandling() {
    case "$1" in
    "1")
        echo -e "${red}ERROR${reset}: System update failed. Are you connected to internet?"
        ;;
    "2")
        echo -e "${red}ERROR${reset}: Could not install packages."
        ;;
    *)
        echo -e "${red}ERROR${reset}: An unexpected issue has occurred."
        ;;
    esac
    exit 1
}

exitScript() {
    local message="$1"
    echo -e ""
    echo -e "${red}${message}${reset}"
    exit 0
}

### PROGRAM START ###

# Trap CTRL+C
trap 'exitScript "Aborted!"' SIGINT

# Get directory
directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Step 1
confirmInstallation

# Step 2
updateSystem

# Step 3
installPackages

# Step 4
chooseGpuDriver

# Step 5
chooseExtras

# Step 6
configureGit

# Step 7
installOhMyZsh

# Step 8
installTmuxPlugins

# Step 9
copyFiles

# Step 10
changeShell

# Step 11
enableServices

# Step 12
finished
