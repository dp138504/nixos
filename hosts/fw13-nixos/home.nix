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

  # Toggleable modules defined in ../../modules/home-manager/
  profiles.home = {
    wezterm.enable = true; # Enable wezterm settings
    tmux.enable = true; # Enable tmux settings
    texlive.enable = true; # Enable TeXLive distribution
    zsh.enable = true; # Enable Z-shell customizations
    autorandr.enable = true; # Enables autorandr of connected monitors
    i3 = {
      enable = true; # Enable i3wm and supporting applications
      colemak = true; # Colemak keybindings when docked
    };
  };

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
      profiles.home.i3 = {
        colemak = lib.mkForce false;
        qwerty = true;
      };
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
      inputs.zen-browser.packages."${system}".default
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
    sessionVariables = {
      EDITOR = "nvim";
    };
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
