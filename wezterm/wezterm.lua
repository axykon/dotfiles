local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = 'Dracula (Official)'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 13
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.enable_kitty_keyboard = false
config.leader = { key = 'q', mods = 'CTRL' }
config.keys = {
   {
	  key = 'C',
	  mods = 'CTRL',
	  action = act.CopyTo 'ClipboardAndPrimarySelection'
   },
	{
		key = '%',
		mods = 'LEADER|SHIFT',
		action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
		key = '"',
		mods = 'LEADER|SHIFT',
		action = act.SplitVertical { domain = 'CurrentPaneDomain' },
	},
	{
		key = '`',
		mods = 'ALT',
		action = act.ActivateLastTab,
	},
	{
		key = 'o',
		mods = 'LEADER',
		action = act.ActivateLastTab,
	},
	{
		key = 'h',
		mods = 'LEADER',
		action = act.ActivatePaneDirection 'Left',
	},
	{
		key = 'j',
		mods = 'LEADER',
		action = act.ActivatePaneDirection 'Down',
	},
	{
		key = 'k',
		mods = 'LEADER',
		action = act.ActivatePaneDirection 'Up',
	},
	{
		key = 'l',
		mods = 'LEADER',
		action = act.ActivatePaneDirection 'Right',
	},
    {
        key = ' ',
        mods = 'LEADER',
        action = act.PaneSelect,
    },
    {
        key = ' ',
        mods = 'LEADER|CTRL',
        action = act.PaneSelect {
            mode = 'SwapWithActive',
        },
    },
	{
		key = 'z',
		mods = 'LEADER',
		action = act.TogglePaneZoomState,
	},
	{
	   key = '0',
	   mods = 'LEADER',
	   action = act.ActivateLastTab,
	},
    {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = 'LEADER',
		action = act.ActivateTab(i - 1),
	})
end

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_decorations = 'RESIZE'
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

function recompute_padding(window)
  local window_dims = window:get_dimensions()
  local overrides = window:get_config_overrides() or {}

  if not window_dims.is_full_screen then
    if not overrides.window_padding then
      -- not changing anything
      return
    end
    overrides.window_padding = nil
  else
    -- Use only the middle 33%
    local third = math.floor(window_dims.pixel_width / 3)
    local new_padding = {
      left = third,
      right = third,
      top = 5,
      bottom = 0,
    }
    if
      overrides.window_padding
      and new_padding.left == overrides.window_padding.left
    then
      -- padding is same, avoid triggering further changes
      return
    end
    overrides.window_padding = new_padding
  end
  window:set_config_overrides(overrides)
end

wezterm.on('window-resized', function(window, pane)
  recompute_padding(window)
end)

wezterm.on('window-config-reloaded', function(window)
  recompute_padding(window)
end)

return config
