{ config, lib, pkgs, ...}:
{
  options = {
    texlive.enable = lib.mkEnableOption "Enables texlive with Acrotex";
  };

  config = lib.mkIf config.texlive.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; inherit (pkgs) acrotex; };
    };
  };
}
