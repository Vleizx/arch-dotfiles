#!/bin/bash

# Obtengo la IP del archivo WAN
ip_address=$(awk '{print $1}' "$HOME/.config/bin/wan")

# Copio sin dejar salto de linea
echo -n "$ip_address" | xclip -sel clip

# Notifico IP copiada
notify-send "[WAN Copied]" "IP: $ip_address"
