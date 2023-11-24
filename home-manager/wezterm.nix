{ config, ... }: {
  programs.wezterm = {
    enable = true;

    colorSchemes.nix-colors = {
      ansi = [
        "#${config.colorScheme.colors.base00}"
        "#${config.colorScheme.colors.base08}"
        "#${config.colorScheme.colors.base0B}"
        "#${config.colorScheme.colors.base0A}"
        "#${config.colorScheme.colors.base0D}"
        "#${config.colorScheme.colors.base0E}"
        "#${config.colorScheme.colors.base0C}"
        "#${config.colorScheme.colors.base05}"
      ];
      brights = [
        "#${config.colorScheme.colors.base00}"
        "#${config.colorScheme.colors.base08}"
        "#${config.colorScheme.colors.base0B}"
        "#${config.colorScheme.colors.base0A}"
        "#${config.colorScheme.colors.base0D}"
        "#${config.colorScheme.colors.base0E}"
        "#${config.colorScheme.colors.base0C}"
        "#${config.colorScheme.colors.base05}"
      ];
      background = "#${config.colorScheme.colors.base00}";
      cursor_bg = "#${config.colorScheme.colors.base06}";
      cursor_border = "#${config.colorScheme.colors.base06}";
      cursor_fg = "#${config.colorScheme.colors.base00}";
      foreground = "#${config.colorScheme.colors.base06}";
      selection_bg = "#${config.colorScheme.colors.base05}";
      selection_fg = "#${config.colorScheme.colors.base00}";
    };
    extraConfig = ''
      local config = {
        window_background_opacity = 0.9,
        text_background_opacit = 0.9,
        color_scheme = "nix-colors",
        tab_bar_at_bottom = true,
        hide_tab_bar_if_only_one_tab = true
        --window_frame = {
        --  font = wezterm.font { family = 'Jetbrains Mono', weight = 'Normal' }
        --}
      }
      return config
    '';
  };
}
