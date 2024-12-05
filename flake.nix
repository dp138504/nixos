{
  description = "Framework 13 NixOS Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
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

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hardware,
      nix-colors,
      kickstart-nix-nvim,
      sddm-surgar-candy-nix,
      nixos-cosmic,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        fw13-nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/fw13-nixos/configuration.nix
            ./modules/nixos
            hardware.nixosModules.framework-13th-gen-intel
            hardware.nixosModules.common-gpu-nvidia-nonprime
            sops-nix.nixosModules.sops
            sddm-surgar-candy-nix.nixosModules.default
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "dap@fw13-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs nix-colors;
          };
          modules = [
            ./hosts/fw13-nixos/home.nix
            ./modules/home-manager
          ];
        };
        "dap" = home-manager.lib.homeManagerConfiguration {
          # Kali Config
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs nix-colors;
          };
          modules = [
            ./hosts/fw13-kali/home.nix
            ./modules/home-manager
          ];
        };
        "dap@dylan-acenet" = home-manager.lib.homeManagerConfiguration {
          # Work Config
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs nix-colors;
          };
          modules = [
            ./hosts/dylan-acenet/home.nix
            ./modules/home-manager
          ];
        };
      };
    };
}
