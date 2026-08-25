#!/bin/bash

# Obtengo la IP del archivo LAN
ip_address=$(awk '{print $1}' "$HOME/.config/bin/lan")

# Copio sin dejar salto de linea
echo -n "$ip_address" | xclip -sel clip

# Notifico IP copiada
notify-send "[LAN Copied]" "IP: $ip_address"
