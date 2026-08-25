#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

RICE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SRC="$RICE_DIR/dotfiles"
BACKUP_DIR="$HOME/.RiceBackup/$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$HOME/RiceInstall.log"

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    RED=$(tput setaf 1)
    YELLOW=$(tput setaf 3)
    GREEN=$(tput setaf 2)
    BLUE=$(tput setaf 4)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED='' YELLOW='' GREEN='' BLUE='' BOLD='' RESET=''
fi

log() {
    printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*" | tee -a "$LOG_FILE"
}

info() { log "${BLUE}INFO${RESET}: $*"; }
ok() { log "${GREEN}OK${RESET}: $*"; }
warn() { log "${YELLOW}WARN${RESET}: $*"; }
die() { log "${RED}ERROR${RESET}: $*"; exit 1; }

usage() {
    cat <<'EOF'
Usage: ./install.sh [--change-shell]

Installs the Valerie bspwm rice on Arch Linux over X11.
The script uses official Arch packages only. Themes, fonts and local
runtime binaries are bundled in this repository.
EOF
}

CHANGE_SHELL=0
for arg in "$@"; do
    case "$arg" in
        --change-shell) CHANGE_SHELL=1 ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown option: $arg" ;;
    esac
done

initial_checks() {
    [[ "$(id -u)" -ne 0 ]] || die "Do not run this script as root."
    [[ -f /etc/arch-release ]] || die "This installer only supports Arch Linux."
    command -v pacman >/dev/null 2>&1 || die "pacman is required."
    command -v sudo >/dev/null 2>&1 || die "sudo is required."
    [[ -d "$SRC/config" ]] || die "Missing dotfiles/config directory."
    [[ -d "$SRC/local" ]] || die "Missing bundled local assets."
    [[ "$(uname -m)" == "x86_64" ]] || die "Bundled Eww and i3lock binaries currently support x86_64 only."
    sudo -v || die "sudo authentication failed."
}

read_package_list() {
    local file="$1"
    local -n result="$2"
    result=()

    while IFS= read -r package || [[ -n "$package" ]]; do
        [[ -z "$package" || "$package" == \#* ]] && continue
        result+=("$package")
    done < "$file"
}

install_packages() {
    local packages=()
    read_package_list "$RICE_DIR/packages/official.txt" packages
    ((${#packages[@]} > 0)) || die "No official packages were defined."

    info "Installing Valerie dependencies from official Arch repositories."
    sudo pacman -Syu --needed --noconfirm "${packages[@]}"
    ok "Official packages installed."
}

backup_item() {
    local item="$1"
    if [[ -e "$item" || -L "$item" ]]; then
        local relative_path="${item#"$HOME"/}"
        local backup_item_path="$BACKUP_DIR/$relative_path"
        mkdir -p -- "$(dirname "$backup_item_path")"
        mv -- "$item" "$backup_item_path"
    fi
}

backup_existing() {
    mkdir -p "$BACKUP_DIR"

    local config_dir
    for config_dir in \
        bspwm alacritty clipcat polybar dunst mpd ncmpcpp yazi geany \
        gtk-3.0 gtk-4.0 networkmanager-dmenu Thunar; do
        backup_item "$HOME/.config/$config_dir"
    done

    backup_item "$HOME/.config/bin"
    backup_item "$HOME/.config/systemd/user/ArchUpdates.service"
    backup_item "$HOME/.config/systemd/user/ArchUpdates.timer"
    backup_item "$HOME/.local/share/themes/Flat-Remix-GTK-Red-Darkest-Solid"
    backup_item "$HOME/.local/share/icons/Dracula"
    backup_item "$HOME/.local/share/icons/Qogirr-Dark"
    local font_file
    for font_file in "$SRC/local/share/fonts"/*; do
        [[ -f "$font_file" ]] || continue
        backup_item "$HOME/.local/share/fonts/$(basename "$font_file")"
    done
    backup_item "$HOME/.local/bin/eww"
    backup_item "$HOME/.local/bin/i3lock"

    local home_file
    for home_file in .zshrc .fehbg .xsettingsd .gtkrc-2.0; do
        backup_item "$HOME/$home_file"
    done
    backup_item "$HOME/.icons/default"

    ok "Existing configuration backed up to $BACKUP_DIR."
}

copy_config_dir() {
    local name="$1"
    [[ -d "$SRC/config/$name" ]] || return 0
    if [[ "$name" == systemd ]]; then
        mkdir -p "$HOME/.config/systemd/user"
        cp -a -- "$SRC/config/systemd/." "$HOME/.config/systemd/user/"
    else
        cp -a -- "$SRC/config/$name" "$HOME/.config/"
    fi
}

copy_dotfiles() {
    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share"

    local config_dir
    for config_dir in \
        bspwm alacritty clipcat polybar dunst mpd ncmpcpp yazi geany \
        gtk-3.0 gtk-4.0 networkmanager-dmenu Thunar systemd; do
        copy_config_dir "$config_dir"
    done

    if [[ -d "$SRC/config/bin" ]]; then
        cp -a -- "$SRC/config/bin" "$HOME/.config/"
    fi

    if [[ -d "$SRC/home/.icons" ]]; then
        cp -a -- "$SRC/home/.icons" "$HOME/"
    fi

    local home_file
    for home_file in .zshrc .fehbg .xsettingsd .gtkrc-2.0; do
        [[ -f "$SRC/home/$home_file" ]] && cp -a -- "$SRC/home/$home_file" "$HOME/"
    done

    cp -a -- "$SRC/local/bin/." "$HOME/.local/bin/"
    mkdir -p "$HOME/.local/share/themes" "$HOME/.local/share/icons" "$HOME/.local/share/fonts"
    cp -a -- "$SRC/local/share/themes/." "$HOME/.local/share/themes/"
    cp -a -- "$SRC/local/share/icons/." "$HOME/.local/share/icons/"
    cp -a -- "$SRC/local/share/fonts/." "$HOME/.local/share/fonts/"

    printf '%s\n' valerie > "$HOME/.config/bspwm/.rice"

    find "$HOME/.config/bspwm/bin" "$HOME/.config/bin" "$HOME/.local/bin" \
        -type f -exec chmod u+x {} +
    chmod u+x "$HOME/.fehbg" 2>/dev/null || true

    ok "Valerie dotfiles, Thunar configuration, themes and fonts copied."
}

configure_dark_mode() {
    command -v gsettings >/dev/null 2>&1 || return 0
    gsettings writable org.gnome.desktop.interface color-scheme >/dev/null 2>&1 || return 0

    gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true
    gsettings set org.gnome.desktop.interface gtk-theme Flat-Remix-GTK-Red-Darkest-Solid || true
    gsettings set org.gnome.desktop.interface icon-theme Dracula || true
    gsettings set org.gnome.desktop.interface cursor-theme Qogirr-Dark || true
}

configure_hardware() {
    local vars="$HOME/.config/bspwm/bin/SetSysVars"
    [[ -x "$vars" ]] && "$vars"
}

configure_services() {
    mkdir -p "$HOME/.config/systemd/user" "$HOME/.config/mpd/playlists"
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now mpd.service 2>/dev/null || \
        warn "MPD user service could not start; it can be enabled after logging into a graphical session."
    systemctl --user enable --now ArchUpdates.timer 2>/dev/null || \
        warn "ArchUpdates.timer could not start; it can be enabled after logging into a graphical session."
    fc-cache -f "$HOME/.local/share/fonts" "$HOME/.local/share/icons" 2>/dev/null || fc-cache -f 2>/dev/null || true
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f -t "$HOME/.local/share/icons/Dracula" 2>/dev/null || true
        gtk-update-icon-cache -f -t "$HOME/.local/share/icons/BeautyLine" 2>/dev/null || true
    fi
    xdg-user-dirs-update 2>/dev/null || true
}

change_shell() {
    [[ "$CHANGE_SHELL" -eq 1 ]] || return 0
    local zsh_path
    zsh_path=$(command -v zsh)
    [[ -n "$zsh_path" ]] || return 0
    [[ "${SHELL:-}" == "$zsh_path" ]] || chsh -s "$zsh_path"
}

finish() {
    printf '\n%bValerie installation complete.%b\n' "$GREEN$BOLD" "$RESET"
    printf 'Backup: %s\n' "$BACKUP_DIR"
    printf 'Log:    %s\n\n' "$LOG_FILE"
    printf '%bLog out and start bspwm from your display manager or ~/.xinitrc.%b\n' "$YELLOW" "$RESET"
    printf 'Optional shell change: %s --change-shell\n' "$0"
}

initial_checks
install_packages
backup_existing
copy_dotfiles
configure_dark_mode
configure_hardware
configure_services
change_shell
finish
