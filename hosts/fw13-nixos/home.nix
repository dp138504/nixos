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
    ../../modules/home-manager/services/stylix.nix
  ];

  # Toggleable modules defined in ../../modules/home-manager/
  profiles.home = {
    wezterm.enable = true; # Enable wezterm settings
    tmux.enable = true; # Enable tmux settings
    texlive.enable = true; # Enable TeXLive distribution
    zsh.enable = true; # Enable Z-shell customizations
    autorandr.enable = false; # Enables autorandr of connected monitors
    hyprland = {
      enable = true; # Enable hyprland and supporting applications
      colemak = true; # Colemak keybindings when docked
    };
    i3 = {
      enable = false; # Enable i3wm and supporting applications
      colemak = true; # Colemak keybindings when docked
    };
  };

  services.udiskie = {
    enable = true;
    automount = false;
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
      profiles.home.hyprland = {
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
      ## Communications ##
      slack # Work communications
      skypeforlinux # Skype for video chats
      unstable.discord # Personal commuications

      ## Utilities ##
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # Preferred font
      nixfmt-rfc-style # Nix file linter
      bitwarden # Password manager
      tmux # Terminal multiplexer
      tree # Directory tree visualizer
      unzip # Unzip utility
      nvim-pkg # Nix neovim flake
      gnupg # PGP client
      galculator # Calculator
      tailscale # Tailscale Mesh VPN
      file
      openssl
     
      ## DevOps ##
      terraform
      packer
      tf-summarize
      talosctl
      kubectl
      kubectl-cnpg
      kubecolor
      kubernetes-helm
      minio-client

      ## Graphical ##
      inkscape # Vector image editor
      gimp # Raster image editor
      imagemagick # Needed for plugins in inkscape

      ## 3D Printing ##
      super-slicer-latest # 3D slicing program
      unstable.prusa-slicer

      ## SDR ##
      chirp
      sdrangel

      ## Desktop Applications ##
      unstable.ytmdesktop # YouTube Music desktop client
      obsidian # Notes
      inputs.zen-browser.packages."${system}".default # Zen browser

    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Missing desktop entries
  xdg.desktopEntries = {
    chirp = {
      name = "Chirp Radio Programmer";
      genericName = "Radio Programmer";
      exec = "chirp";
      terminal = false;
      categories = [ "Audio" "Utility" "HamRadio" ];
      icon = "${pkgs.chirp}/lib/python3.12/site-packages/chirp/share/chirp.svg";
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
    initExtra = "compdef kubecolor=kubectl";
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/#fw13-nixos";
      update = "home-manager switch --flake /etc/nixos/#dap@fw13-nixos";
      k = "kubectl";
      kubectl = "kubecolor"; # Colorize kubectl output
      kn = "f() { [ \"$1\" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d\" \" -f6 ; } ; f";
      vim = "nvim";
      open = "xdg-open";
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
