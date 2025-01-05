{ pkgs, ... }:
{
  acrotex = pkgs.callPackage ./acrotex.nix { };
}
