#!/bin/bash

# Lee la dirección IP de la VPN desde el archivo
vpn_add=$(awk '{print $1}' /home/$USER/.config/bin/vpn)

if [ "$vpn_add" ]; then
    echo "%{F#c1001a} VPN: %{F-}%{F#ffee00}$vpn_add%{u-}"
else
    echo "%{F#00000000} VPN: %{u-}%{F#ffee00}"
fi
