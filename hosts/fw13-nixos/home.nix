# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  pkgs,
  nix-colors,
  config,
  lib,
  ...
}:

{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
  ];

  # Toggleable modules defined in ../../homeManagerModules/
  i3.enable = true; # Docked/Undocked keybindings in HomeManager Specializations
  i3.colemak.enable = true;
  wezterm.enable = true;
  autorandr.enable = true;
  tmux.enable = true;
  zsh.enable = true; # System specific aliases defined below
  texlive.enable = true;

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      outputs.overlays.unstable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.kickstart-nix-nvim.overlays.default
    ];

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-24.8.6" # Required for bitwarden
      ];
    };
  };

  # User color theme
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  # User-level fonts
  fonts.fontconfig.enable = true;

  specialisation = {
    undocked.configuration = {
      i3.colemak.enable = lib.mkForce false;
      i3.qwerty.enable = true;
      home.packages = with pkgs; [
        (hiPrio (writeShellApplication {
          name = "toggle-bindings";
          runtimeInputs = with pkgs; [
            home-manager
            coreutils
            ripgrep
          ];
          text = ''
            "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate
          '';
        }))
      ];
    };
  };

  home = {
    username = "dap";
    homeDirectory = "/home/dap";
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      nixfmt-rfc-style
      bitwarden
      tmux
      unstable.vivaldi
      tree
      slack
      haskellPackages.greenclip # Rofi clipboard manager
      skypeforlinux
      unstable.discord
      xclip
      inkscape # Vector image editor
      gimp # Raster image editor
      imagemagick # Needed for plugins in inkscape
      unzip
      super-slicer-latest
      gnupg
      nvim-pkg
      obsidian
      (writeShellApplication {
        name = "toggle-bindings";
        runtimeInputs = with pkgs; [
          home-manager
          coreutils
          ripgrep
        ];
        text = ''
          "$(home-manager generations | head -1 | rg -o '/[^ ]*')"/specialisation/undocked/activate
        '';
      })
    ];
  };

  # Add stuff for your user as you see fit:
  #programs.neovim.enable = true;

  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.ms-vscode-remote.remote-containers
      pkgs.vscode-extensions.ms-vscode.cpptools
    ];
  };

  programs.zsh = {
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/#fw13-nixos";
      update = "home-manager switch --flake /etc/nixos/#dap@fw13-nixos";
      vim = "nvim";
    };
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "pitts.dylan@gmail.com";
    userName = "Dylan A. Pitts";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
