#!/bin/sh

if [ -f "$HOME"/.config/geany/geany.conf ]; then
    sed -i \
        -e "s/color_scheme=.*/color_scheme=$geany_theme.conf/g" \
        "$HOME"/.config/geany/geany.conf
fi
