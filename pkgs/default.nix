{ pkgs, ... }:
{
  acrotex = pkgs.callPackage ./acrotex.nix { };
  additionalTmuxPlugins = pkgs.callPackage ./additionalTmuxPlugins.nix { };
  hamlib_4 = pkgs.callPackage ./hamlib_4.nix { };
  wsjtx = pkgs.qt5.callPackage ./wsjtx.nix { hamlib_4 = pkgs.callPackage ./hamlib_4.nix { }; };
}
