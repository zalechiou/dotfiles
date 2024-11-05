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
config.tab_max_width = 48
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
config.keys = {
    {
        key = 'k',
        mods = 'CTRL|SHIFT|CMD|LEADER',
        action = act.Multiple {
            act.ClearScrollback 'ScrollbackAndViewport',
            act.SendKey { key = 'L', mods = 'CTRL' },
        }
    },
    {
        key = "t",
        mods = "LEADER",
        action = act({ SpawnCommandInNewTab = { cwd = wezterm.home_dir } })
    },
}
config.selection_word_boundary = " \t\n{}[]()<>\"'`"
config.window_padding = {
    bottom = 0,
    left = 0,
    right = 0,
    top = 0,
}

config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 999

function get_max_cols(window)
  local tab = window:active_tab()
  local cols = tab:get_size().cols
  return cols
end

wezterm.on(
  'window-config-reloaded',
  function(window)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'window-resized',
  function(window, pane)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    _max_width = (wezterm.GLOBAL.cols // #tabs)
    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, _max_width - 7)
    pad_length = (_max_width - #title -7) // 2
    title = '[' .. tab.tab_index + 1 .. '] ' .. string.rep(' ', pad_length) .. title .. string.rep(' ', pad_length)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
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
