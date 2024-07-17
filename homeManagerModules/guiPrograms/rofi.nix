{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  options = {
    rofi.enable = lib.mkEnableOption "Enables rofi";
  };

  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = {
        "*" = {
          font = "JetBrainsMono NFM 12";
          bg = mkLiteral "#${config.colorScheme.palette.base00}";
          fg = mkLiteral "#${config.colorScheme.palette.base06}";
          fg2 = mkLiteral "#${config.colorScheme.palette.base02}";
          accent = mkLiteral "#${config.colorScheme.palette.base0B}";
          urgent = mkLiteral "#${config.colorScheme.palette.base08}";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
          accent-color = mkLiteral "@accent";

          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          spacing = mkLiteral "0px";
        };
        "window" = {
          background-color = mkLiteral "@bg";
          border-color = mkLiteral "@accent-color";

          location = mkLiteral "center";
          width = mkLiteral "480px";
          border = mkLiteral "1px";
        };
        "inputbar" = {
          padding = mkLiteral "8px 12px";
          spacing = mkLiteral "12px";
          children = map mkLiteral [
            "icon-search"
            "entry"
          ];
        };
        "icon-search" = {
          expand = false;
          filename = "search";
          size = mkLiteral "28px";
        };
        "entry" = {
          font = mkLiteral "inherit";
          placeholder = "Search...";
          placeholder-color = mkLiteral "@fg2";
        };
        "icon-search, prompt, entry, element-text, element-icon" = {
          vertical-align = mkLiteral "0.5";
        };
        "prompt" = {
          text-color = mkLiteral "@accent-color";
        };
        "listview" = {
          lines = 8;
          columns = 1;
          fixed-height = false;
        };
        "element" = {
          padding = mkLiteral "8px";
          spacing = mkLiteral "8px";
        };
        "element normal urgent" = {
          text-color = mkLiteral "@urgent";
        };
        "element normal active" = {
          text-color = mkLiteral "@accent-color";
        };
        "element selected" = {
          text-color = mkLiteral "@bg";
        };
        "element selected normal" = {
          background-color = mkLiteral "@accent-color";
        };
        "element selected urgent" = {
          background-color = mkLiteral "@urgent";
        };
        "element selected active" = {
          background-color = mkLiteral "@accent";
        };
        "element-icon" = {
          size = mkLiteral "0.75em";
        };
        "element-text" = {
          text-color = mkLiteral "inherit";
        };
      };
    };

    home.file.".config/greenclip.toml".text = ''
      [greenclip]
      blacklisted_applications = []
      enable_image_support = true
      history_file = "/home/dap/.cache/greenclip.history"
      image_cache_directory = "/tmp/greenclip"
      max_history_length = 50
      max_selection_size_bytes = 0
      static_history = [""]
      trim_space_from_selection = true
      use_primary_selection_as_input = false
    '';
  };
}
