--
local wezterm = require 'wezterm'

local act = wezterm.action
local config = wezterm.config_builder()

config.check_for_updates = false
config.color_scheme = 'Tango (terminal.sexy)'
config.font = wezterm.font_with_fallback({'0xProto Nerd Font Mono', 'Cousine', 'Noto Color Emoji', 'Noto Sans CJK JP'})
config.font_size = 12.0
config.hide_mouse_cursor_when_typing = false
config.initial_cols = 132
config.initial_rows = 43
config.line_height = 1.0
config.mouse_bindings = {
    {
        event = {Up = {streak = 1, button = 'Left'}},
        mods = 'NONE',
        action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },
    {
        event = {Down = {streak = 1, button = 'Middle'}},
        mods = 'NONE',
        action = act.Nop,
    },
    {
        event = {Up = {streak = 1, button = 'Middle'}},
        mods = 'NONE',
        action = act.OpenLinkAtMouseCursor,
    }
}
config.selection_word_boundary = " \t\n{}[]()<>\"'`"
config.window_padding = {
    bottom = 0,
    left = 0,
    right = 0,
    top = 0,
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    return 'Tab ' .. tab.tab_index
end)
wezterm.on('format-window-title', function(tab, pane, tabes, panes, config)
    local zoomed = ''
    if tab.active_pane.is_zoomed then
        zoomed = '[Z] '
    end

    local index = ''
    if #tabs > 1 then
        index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end

    return zoomed .. index .. tab.active_pane.title
    -- return 'WezTerm ' .. wezterm.version
end)

return config