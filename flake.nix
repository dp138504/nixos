{
  description = "Framework 13 NixOS Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS Hardware quirks
    hardware.url = "github:nixos/nixos-hardware";

    # NixColors
    nix-colors.url = "github:misterio77/nix-colors";

    # Stylix
    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs"; 

    # Neovim configuration
    #kickstart-nix-nvim.url = "github:dp138504/kickstart-nix.nvim";
    kickstart-nix-nvim.url = "git+file:///home/dap/src/kickstart-nix.nvim";

    # Customizable SDDM theming
    sddm-surgar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
    #  url = "github:wez/wezterm/5243d733532221b746f7921b3ac76c5193f49a3a?dir=nix";
      url = "github:wezterm/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  nixConfig = {
    trusted-users = [
      "dap"
      "root"
    ];
    extra-substituters = [
                  "https://hyprland.cachix.org"
                  "https://wezterm.cachix.org"
    ];
    extra-trusted-public-keys = [
                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                  "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
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
      sops-nix,
      stylix,
      wezterm,
      hyprland,
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
#      nixConfig = {
#              nix.settings = {
#                substituters = [ 
#                  "https://hyprland.cachix.org"
#                  "https://wezterm.cachix.org"
#                ];
#                trusted-public-keys = [ 
#                  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
#                  "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
#                ];
#              };
#      };
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
            stylix.nixosModules.stylix
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
            stylix.homeModules.stylix
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
