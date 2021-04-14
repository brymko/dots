local wezterm = require 'wezterm';

return {
    -- FONTS
    font_size = 10.0;
    
    -- TODO: fallback fonts yo.
    -- sudo pacman -S fft-fira-mono
    font = wezterm.font('Fira Mono Medium', {bold = false, italic=false});

    -- KEYS
    use_dead_keys = false;
    disable_default_key_bindings = true;
    keys = {
        { key = "c", mods = "CTRL|SHIFT", action=wezterm.action{ CopyTo = "ClipboardAndPrimarySelection" }},
        { key = "v", mods = "CTRL|SHIFT", action=wezterm.action{ PasteFrom = "Clipboard" }},
        { key = "+", mods = "CTRL", action = "IncreaseFontSize" },
        { key = "-", mods = "CTRL", action = "DecreaseFontSize" },
        { key = "=", mods = "CTRL", action = "ResetFontSize" },
        { key = "d", mods = "CTRL", action = wezterm.action{CloseCurrentPane={confirm=false}}},
        { key = "j", mods = "CTRL|ALT", action = wezterm.action{ScrollByLine=5}},
        { key = "k", mods = "CTRL|ALT", action = wezterm.action{ScrollByLine=-5}},
        { key = "f", mods = "CTRL", action = wezterm.action{Search={Regex=""}}},
        { key = "m", mods = "CTRL|ALT", action = "ActivateCopyMode" },
    };

    -- shit i already have i3 for
    hide_tab_bar_if_only_one_tab = true;
    window_close_confirmation = "NeverPrompt";

    -- Scrollback
    scrollback_lines = 10000;
    enable_scroll_bar = false;
    
}

