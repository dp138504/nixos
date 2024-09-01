{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.home.texlive;
in
{
  options = {
    profiles.home.texlive = {
      enable = lib.mkEnableOption "Enables TeXLive with AcroTeX for digital signature generation";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-full;
        inherit (pkgs) acrotex;
      };
    };
  };
}
