{
  config,
    pkgs,
    lib,
    ...
}:
{
  options = {
    fuzzel.enable = lib.mkEnableOption "Enables fuzzel launcher";
  };

  config = lib.mkIf config.fuzzel.enable {

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font= lib.mkForce "JetBrains Mono NF:size=12";
          dpi-aware="no";
          icons-enabled="yes";
          terminal="wezterm";
          width="32";
          horizontal-pad="16";
          vertical-pad="8";
          inner-pad="8";
        };

        border = {
          width="2";
          radius="5";
        };
#        colors = {
#          background      ="#282828ff";
#          text            ="#ebdbb2ff";
#          prompt          ="#458588ff";
#          input           ="#ebdbb2ff";
#          match           ="#458588ff";
#          selection       ="#b16286ff";
#          selection-text  ="#282828ff";
#          selection-match ="#282828ff";
#          border          ="#b16286ff";
#        };
      };
    };
  };
}
