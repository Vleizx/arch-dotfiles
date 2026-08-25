#!/bin/sh

YAZI_THEME="$HOME/.config/yazi/theme.toml"

[ -f "$YAZI_THEME" ] || exit 0

sed -i \
    -e "s/^cwd = { fg = .*/cwd = { fg = \"$fg\" }/" \
    -e "s/^normal_main = { bg = .*/normal_main = { bg = \"$accent_color\", fg = \"$bg\", bold = true }/" \
    -e "s/^normal_alt = { bg = .*/normal_alt = { bg = \"$black\", fg = \"$fg\", bold = true }/" \
    -e "s/^overall   = { bold = .*/overall   = { fg = \"$fg\", bold = true }/" \
    -e "s/^title_info  = { fg = .*/title_info  = { fg = \"$green\" }/" \
    -e "s/^title_warn  = { fg = .*/title_warn  = { fg = \"$yellow\" }/" \
    -e "s/^title_error = { fg = .*/title_error = { fg = \"$red\" }/" \
    -e "s/^btn_yes    = { bg = .*/btn_yes    = { bg = \"$accent_color\", fg = \"$bg\", bold = true }/" \
    -e "s/^btn_no     = { bg = .*/btn_no     = { bg = \"$red\", fg = \"$bg\", bold = true }/" \
    -e "s/^hovered         = { reversed = .*/hovered         = { fg = \"$accent_color\", reversed = true }/" \
    -e "s/^tab_active   = { fg = .*/tab_active   = { fg = \"$accent_color\", reversed = true }/" \
    -e "s/^border_style  = { fg = .*/border_style  = { fg = \"$accent_color\", bold = true }/" \
    -e "s/^progress_normal = { fg = .*/progress_normal = { fg = \"$accent_color\", bg = \"$black\" }/" \
    -e "s/^progress_error  = { fg = .*/progress_error  = { fg = \"$red\", bg = \"$black\" }/" \
    "$YAZI_THEME"
