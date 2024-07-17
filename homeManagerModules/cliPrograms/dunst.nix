{
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [ ../services/dunst.nix ];

  options = {
    dunst.enable = lib.mkEnableOption "Enables Dunst";
  };

  disabledModules = [
    "services/dunst.nix" # disable upstream to customize icon path and categories
  ];

  config = lib.mkIf config.dunst.enable {

    services.dunst.enable = true;

    services.dunst.iconTheme = {
      package = pkgs.gruvbox-plus-icons-pack;
      name = "Gruvbox-Plus-Dark";
      size = "24";
    };

    services.dunst.additionalCategories = [ "panel" ];

    services.dunst.settings = {
      global = {
        font = "JetBrainsMono NFM 12";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        sort = true;
        indicate_hidden = true;
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        #geometry = "200x5-6+30";
        width = 256;
        origin = "top-right";
        offset = "10x51";
        transparency = 16;
        idle_threshold = 120;
        monitor = 0;
        follow = "mouse";
        sticky_history = true;
        line_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "#${config.colorScheme.palette.base02}";
        frame_width = 2;
        frame_color = "#${config.colorScheme.palette.base0B}";
        icon_position = "left";
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };

      urgency_low = {
        background = "#${config.colorScheme.palette.base00}";
        foreground = "#${config.colorScheme.palette.base03}";
        timeout = 5;
      };

      urgency_normal = {
        background = "#${config.colorScheme.palette.base00}";
        foreground = "#${config.colorScheme.palette.base06}";
        timeout = 20;
      };

      urgency_critical = {
        background = "#${config.colorScheme.palette.base00}";
        foreground = "#${config.colorScheme.palette.base06}";
        frame_color = "#${config.colorScheme.palette.base08}";
        timeout = 0;
      };
    };
  };
}
