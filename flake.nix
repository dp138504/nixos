{
  description = "Framework 13 NixOS Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/cf28ee258fd5f9a52de6b9865cdb93a1f96d09b7";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS Hardware quirks
    hardware.url = "github:nixos/nixos-hardware";

    # NixColors
    nix-colors.url = "github:misterio77/nix-colors";

    # Neovim configuration
    kickstart-nix-nvim.url = "github:dp138504/kickstart-nix.nvim";
    #kickstart-nix-nvim.url = "git+file:///home/dap/src/kickstart-nix.nvim";

    sddm-surgar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = {
    self,
    nixpkgs,
    home-manager,
    hardware,
    nix-colors,
    kickstart-nix-nvim,
    sddm-surgar-candy-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays { inherit inputs;};
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      fw13-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
	      ./nixos/configuration.nix
	      hardware.nixosModules.framework-13th-gen-intel
        hardware.nixosModules.common-gpu-nvidia-nonprime
        sddm-surgar-candy-nix.nixosModules.default
	    ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "dap@fw13-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs nix-colors;};
        modules = [
	      ./home-manager/home.nix
	    ];
      };
    };
  };
}
