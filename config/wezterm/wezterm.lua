local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.color_scheme = 'GitHub Dark'
config.font_size = 16.0

return config
