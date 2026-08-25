#!/bin/bash

# Lee la dirección IP de la WAN desde el archivo
wan_ip=$(awk '{print $1}' "$HOME/.config/bin/wan")

if [ "$wan_ip" ]; then
    echo "%{F#c1001a} WAN: %{F-}%{F#ffff00}$wan_ip%{u-}"
else
    echo "%{F#00000000} WAN: %{u-}%{F#ffffff}"
fi
