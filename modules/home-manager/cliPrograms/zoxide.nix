{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.home.zoxide;
in
{

  options = {
    profiles.home.zoxide.enable = lib.mkEnableOption "Enables zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
