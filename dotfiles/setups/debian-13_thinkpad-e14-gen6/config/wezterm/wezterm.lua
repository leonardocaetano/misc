-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Leo, just put your stuff here! (from here until before return config)

-- config.color_scheme = 'Ibm 3270 (High Contrast) (Gogh)'
config.enable_tab_bar = false
config.font = wezterm.font 'Liberation Mono'
window_decorations = "NONE"
adjust_window_size_when_changing_font_size = false -- this needs to be disabled when using a tiling wm
config.font_size = 12.0
config.default_cursor_style = "SteadyBar"
config.window_padding = 
{
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

if wezterm.target_triple:match("windows") then
	config.default_prog = {'powershell.exe', '-NoLogo', '-NoProfile', '-noe', '-Command', '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 3180fa66 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}'}
	config.default_cwd = "c:\\dev"
end

-- and finally, return the configuration to wezterm
return config
