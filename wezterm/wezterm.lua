local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.color_scheme = 'GitHub Dark'
config.font_size = 16.0
config.font = wezterm.font("MesloLGS Nerd Font Mono")

return config
