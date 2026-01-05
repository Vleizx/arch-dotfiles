#!/usr/bin/env bash

CRE=$(tput setaf 1); CYE=$(tput setaf 3); CGR=$(tput setaf 2)
CBL=$(tput setaf 4); BLD=$(tput bold); CNC=$(tput sgr0)

backup_folder=~/.RiceBackup
ERROR_LOG="$HOME/RiceError.log"

logo() {
    echo -e "\n${BLD}${CBL}Rice Installer by Vleiz${CNC}"
    echo -e "${BLD}${CRE}[ ${CYE}${1} ${CRE}]${CNC}\n"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$ERROR_LOG"
    printf "%s%sERROR:%s %s\n" "${CRE}" "${BLD}" "${CNC}" "$1" >&2
}

initial_checks() {
    if [ "$(id -u)" = 0 ]; then
        log_error "No ejecutes este script como root."
        exit 1
    fi
    if ! ping -q -c 1 -W 1 8.8.8.8 &>/dev/null; then
        log_error "No hay conexión a internet."
        exit 1
    fi
}

install_packages() {
    logo "Instalando paquetes"
    
    local dependencies=(
        "bspwm" "sxhkd" "polybar" "picom" "rofi" "dunst" "alacritty" 
        "zsh" "neovim" "feh" "papirus-icon-theme" "ttf-jetbrains-mono"
        "paru" "git" "base-devel"
    )

    sudo pacman -S --needed --noconfirm "${dependencies[@]}" 2>> "$ERROR_LOG"
}

clone_dotfiles() {
    logo "Descargando Dotfiles"
    local repo_url="TU_URL_DE_GITHUB_AQUI"
    local repo_dir="$HOME/dotfiles_temp"

    [ -d "$repo_dir" ] && rm -rf "$repo_dir"
    
    if git clone --depth=1 "$repo_url" "$repo_dir" >> "$ERROR_LOG" 2>&1; then
        echo -e "${CGR}Dotfiles descargados correctamente.${CNC}"
    else
        log_error "Error al clonar el repositorio."
        exit 1
    fi
}

backup_and_install() {
    logo "Instalando configuración"
    mkdir -p "$backup_folder"
    local repo_dir="$HOME/dotfiles_temp"

    for folder in "$repo_dir/config"/*; do
        [ -e "$folder" ] || continue
        local name=$(basename "$folder")
        [ -d "$HOME/.config/$name" ] && mv "$HOME/.config/$name" "$backup_folder/${name}_backup"
        cp -R "$folder" "$HOME/.config/"
        echo -e "  ${CGR}✔${CNC} $name instalado"
    done

    for file in "$repo_dir/home"/*; do
        [ -e "$file" ] || continue
        local name=$(basename "$file")
        [ -f "$HOME/$name" ] && mv "$HOME/$name" "$backup_folder/${name}_backup"
        cp "$file" "$HOME/"
        echo -e "  ${CGR}✔${CNC} $name instalado"
    done

    mkdir -p "$HOME/.local/share/fonts" "$HOME/.local/bin"
    cp -R "$repo_dir/misc/fonts"/* "$HOME/.local/share/fonts/" 2>/dev/null
    cp -R "$repo_dir/misc/bin"/* "$HOME/.local/bin/" 2>/dev/null
    fc-cache -fv >/dev/null
}

finalize() {
    logo "Finalizando"
    local zsh_path=$(which zsh)
    if [ -x "$zsh_path" ]; then
        sudo chsh -s "$zsh_path" "$USER"
    fi
    
    rm -rf "$HOME/dotfiles_temp"
    echo -e "${CGR}Rice instalado exitosamente.${CNC}"
}

initial_checks
install_packages
clone_dotfiles
backup_and_install
finalize
