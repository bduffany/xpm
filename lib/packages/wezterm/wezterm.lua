local wezterm = require 'wezterm';

-- Determine the modifier key based on the OS
-- CTRL on Linux/Windows, CMD on macOS
local MOD = "CTRL"
if wezterm.target_triple:find("darwin") then
  MOD = "CMD"
end

return {
  keys = {
    -- Ctrl+Shift+Right to activate the next tab
    {
      key="RightArrow",
      mods=MOD.."|SHIFT",
      action=wezterm.action{ActivateTabRelative=1},
    },
    -- Ctrl+Shift+Left to activate the previous tab
    {
      key="LeftArrow",
      mods=MOD.."|SHIFT",
      action=wezterm.action{ActivateTabRelative=-1},
    },
    -- Add any additional key bindings here
  },
  -- Add other configuration options below
}