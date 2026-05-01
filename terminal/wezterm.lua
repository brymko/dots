local wezterm = require 'wezterm';
local mux = wezterm.mux
local act = wezterm.action

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {}) window:gui_window():maximize()
end)

return {
    -- Disable update notifications
    check_for_updates = false,

    -- bell 
    audible_bell = "Disabled";

    -- FONTS
    font_size = 13.0;
    line_height = 0.8;
    
    -- TODO: fallback fonts yo.
    -- sudo pacman -S fft-fira-mono
    -- font = wezterm.font_with_fallback({'CommitMono Nerd Font', 'codicon.ttf'});
    font = wezterm.font_with_fallback({'JetBrains Mono', 'codicon.ttf'});
    -- font = wezterm.font('mononoki Nerd Font', {stretch = "Normal", weight = "Regular", italic=false});
    -- font = wezterm.font('DM Mono Light', {stretch = "Normal", weight = "Regular", italic=false});
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" };

    -- KEYS
    use_dead_keys = false;
    -- disable_default_key_bindings = true;

    -- shit i already have i3 for
    hide_tab_bar_if_only_one_tab = true;
    window_close_confirmation = "NeverPrompt";

    -- Scrollback
    scrollback_lines = 10000;
    enable_scroll_bar = false;

    -- no hyperlinks
    hyperlink_rules = {
        {
            regex = "",
            format ="$0",
        },
    };

    -- no padding
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    };

    use_cap_height_to_scale_fallback_fonts = true;
    adjust_window_size_when_changing_font_size = false;
    allow_square_glyphs_to_overflow_width = "Always";
    custom_block_glyphs = false;

    colors = {
        selection_bg = '#524254',
    };

    keys = {
        { key = "c", mods = "CTRL|SHIFT", action=wezterm.action{ CopyTo = "ClipboardAndPrimarySelection" }},
        { key = "v", mods = "CTRL|SHIFT", action=wezterm.action{ PasteFrom = "Clipboard" }},
        { key = "+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
        { key = "-", mods = "CTRL", action = "DecreaseFontSize" },
        { key = "=", mods = "CTRL", action = "ResetFontSize" },
        { key = "j", mods = "CTRL|ALT", action = wezterm.action{ScrollByLine=5}},
        { key = "k", mods = "CTRL|ALT", action = wezterm.action{ScrollByLine=-5}},
        { key = "f", mods = "CTRL", action = wezterm.action{Search={Regex=""}}},
        { key = "m", mods = "CTRL|ALT", action = "ActivateCopyMode" },
        -- Keep plain Option mostly free for AeroSpace; Alt+F zooms the current pane.
        { key = 'f', mods = "OPT", action = act.TogglePaneZoomState },
        { key = "g", mods = "CMD", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
        { key = "b", mods = "CMD", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
        { key = 'h', mods = "CMD", action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = "CMD", action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = "CMD", action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = "CMD", action = act.ActivatePaneDirection 'Down' },
        { key = 'w', mods = "CMD", action = act.CloseCurrentPane{ confirm = true } },
    };
}

