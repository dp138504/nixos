{ pkgs, ... }:
{
  acrotex = pkgs.callPackage ./acrotex.nix { };
  additionalTmuxPlugins = pkgs.callPackage ./additionalTmuxPlugins.nix { };
}
