#!/bin/bash

# Obtengo la IP del archivo TARGET
ip_address=$(awk '{print $1}' "$HOME/.config/bin/vpn")

# Copio sin dejar salto de linea
echo -n "$ip_address" | xclip -sel clip

# Notifico IP copiada
notify-send "[VPN Copied]" "IP: $ip_address"
