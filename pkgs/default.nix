{ pkgs, ... }: {
  gruvbox-plus-icons-pack = pkgs.callPackage ./gruvbox-plus-icons-pack.nix { };
  acrotex = pkgs.callPackage ./acrotex.nix {};
}
