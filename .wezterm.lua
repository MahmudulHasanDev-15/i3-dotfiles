-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- config.colors = {
--	foreground = "#CBE0F0",
--	background = "#011423",
--	cursor_bg = "#47FF9C",
--	cursor_border = "#47FF9C",
--	cursor_fg = "#011423",
--	selection_bg = "#033259",
--	selection_fg = "#CBE0F0",
--	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", #"#a277ff", "#24EAF7", "#24EAF7" },
--	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", #"#a277ff", "#24EAF7", "#24EAF7" },
--}

-- color_scheme = "Tokyo Night"
-- Custom color scheme
config.color_schemes = {
  ["Custom Mocha"] = {
    foreground = "#cdd6f4",
    background = "#1e1e2e",
    cursor_bg = "#f5e0dc",
    cursor_border = "#f5e0dc",
    cursor_fg = "#1e1e2e",
    selection_bg = "#f5e0dc",
    selection_fg = "#1e1e2e",

   ansi = {
      "#45475a", -- black
      "#f38ba8", -- red
      "#a6e3a1", -- green
      "#f9e2af", -- yellow
     "#89b4fa", -- blue
      "#f5c2e7", -- magenta
      "#94e2d5", -- cyan
      "#bac2de", -- white
    },
    brights = {
      "#585b70", -- bright black
      "#f38ba8", -- bright red
      "#a6e3a1", -- bright green
      "#f9e2af", -- bright yellow
      "#89b4fa", -- bright blue
      "#f5c2e7", -- bright magenta
      "#94e2d5", -- bright cyan
      "#a6adc8", -- bright white
    },
  }
}

-- Apply the custom scheme
config.color_scheme = "Custom Mocha"

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 12

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.7
config.text_background_opacity = 0.95


-- and finally, return the configuration to wezterm
return config
