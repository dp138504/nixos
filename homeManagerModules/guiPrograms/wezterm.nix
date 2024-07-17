{ config, lib, ... }:
{

  options = {
    wezterm.enable = lib.mkEnableOption "Fnables wezterm";
  };

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;

      colorSchemes.nix-colors = {
        ansi = [
          "#${config.colorScheme.palette.base00}"
          "#${config.colorScheme.palette.base08}"
          "#${config.colorScheme.palette.base0B}"
          "#${config.colorScheme.palette.base0A}"
          "#${config.colorScheme.palette.base0D}"
          "#${config.colorScheme.palette.base0E}"
          "#${config.colorScheme.palette.base0C}"
          "#${config.colorScheme.palette.base05}"
        ];
        brights = [
          "#${config.colorScheme.palette.base00}"
          "#${config.colorScheme.palette.base08}"
          "#${config.colorScheme.palette.base0B}"
          "#${config.colorScheme.palette.base0A}"
          "#${config.colorScheme.palette.base0D}"
          "#${config.colorScheme.palette.base0E}"
          "#${config.colorScheme.palette.base0C}"
          "#${config.colorScheme.palette.base05}"
        ];
        background = "#${config.colorScheme.palette.base00}";
        cursor_bg = "#${config.colorScheme.palette.base06}";
        cursor_border = "#${config.colorScheme.palette.base06}";
        cursor_fg = "#${config.colorScheme.palette.base00}";
        foreground = "#${config.colorScheme.palette.base06}";
        selection_bg = "#${config.colorScheme.palette.base05}";
        selection_fg = "#${config.colorScheme.palette.base00}";
      };
      extraConfig = ''
        return {      
          window_background_opacity = 0.9,
          text_background_opacity = 0.9,
          color_scheme = 'Gruvbox dark, medium (base16)',
          tab_bar_at_bottom = true,
          hide_tab_bar_if_only_one_tab = true,
        } 
      '';
    };
  };
}
