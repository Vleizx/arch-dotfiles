#############################
#		Vleiz Theme			#
#############################

bg="#0a0000"
fg="#b80707"

black="#000000"          # tinieblas puras
red="#ff0040"            # rojo neón eléctrico
green="#ff4500"          # naranja rojizo neón
yellow="#ff6600"         # naranja fuego neón
blue="#ff0080"           # magenta neón brillante
magenta="#ff1493"        # rosa shocking neón
cyan="#ff69b4"           # rosa caliente neón
white="#ff6b9d"          # rosa neón suave
blackb="#4d1a1a"         # gris rojizo profundo
redb="#ff1a40"           # rojo carmesí brillante
greenb="#d2691e"         # naranja rojizo chocolate
yellowb="#ff4500"        # rojo-naranja intenso
blueb="#b22222"          # rojo ladrillo brillante
magentab="#dc143c"       # carmesí clásico
cyanb="#cd5c5c"          # rojo indio suave
whiteb="#ffc0cb"         # rosa claro cálido
accent_color="#ff0000"
arch_icon="#c1001a"

# Bspwm options
BORDER_WIDTH="2"		# Bspwm border
TOP_PADDING="43"
BOTTOM_PADDING="1"
LEFT_PADDING="1"
RIGHT_PADDING="1"
NORMAL_BC="#000000"		# Normal border color
FOCUSED_BC="#c1001a"	# Focused border color

# Terminal font & size
term_font_size="10"
term_font_name="JetBrainsMono Nerd Font"

# Picom options
P_FADE="false"			# Fade true|false
P_SHADOWS="false"		# Shadows true|false
SHADOW_C="#000000"		# Shadow color
P_CORNER_R="10"			# Corner radius (0 = disabled)
P_BLUR="false"			# Blur true|false
P_ANIMATIONS="#"		# (@ = enable) (# = disable)
P_TERM_OPACITY="0.9"	# Terminal transparency. Range: 0.1 - 1.0 (1.0 = disabled)

# Dunst
dunst_offset='(20, 60)'
dunst_origin='top-right'
dunst_transparency='50'
dunst_corner_radius='0'
dunst_font='Inconsolata Semi Condensed Extra Bold 9'
dunst_border='2'
dunst_frame_color="$black"
dunst_icon_theme="BeautyLine"
# Dunst animations
dunst_close_preset="fly-out"
dunst_close_direction="up"
dunst_open_preset="fly-in"
dunst_open_direction="right"

# Jgmenu colors
jg_bg="$bg"
jg_fg="$fg"
jg_sel_bg="$yellow"
jg_sel_fg="$bg"
jg_sep="$red"

# Rofi menu font and colors
rofi_font="Terminess Nerd Font Mono Bold 10"
rofi_background="${bg}F0"
rofi_bg_alt="$accent_color"
rofi_background_alt="${bg}E0"
rofi_fg="$fg"
rofi_selected="${red}f0"
rofi_active="$green"
rofi_urgent="$red"

# Screenlocker
sl_bg="${bg}"
sl_fg="${fg}"
sl_ring="${red}"
sl_wrong="${red}"
sl_date="${yellow}"
sl_verify="${green}"

# Gtk theme
gtk_theme="Flat-Remix-GTK-Red-Darkest-Solid"
gtk_icons="Dracula"
gtk_cursor="Qogirr-Dark"
geany_theme="gothic-blood"

# Wallpaper engine
# Available engines:
# - Theme	(Set a random wallpaper from rice directory)
# - CustomDir	(Set a random wallpaper from the directory you specified)
# - CustomImage	(Sets a specific image as wallpaper)
# - CustomAnimated (Set an animated wallpaper. "mp4, mkv, gif")
# - Slideshow (Change randomly every 15 minutes your wallpaper from Walls rice directory)
ENGINE="Default"

CUSTOM_WALL="/path/to/image"
CUSTOM_ANIMATED="$HOME/.config/bspwm/config/assets/animated_wall.mp4"
CUSTOM_DIR="/path/to/your/wallpapers/directory"
DEFAULT_WALL="$HOME/.config/bspwm/rices/valerie/walls/1358293.jpeg"
ANIMATED_WALL="$HOME/.config/bspwm/config/assets/animated_wall.mp4"
