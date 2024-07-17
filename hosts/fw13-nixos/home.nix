# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ config, lib, inputs, outputs, pkgs, nix-colors, ... }:

{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
  ];

  # Toggleable modules defined in ../../homeManagerModules/
  i3.enable = true;
  polybar.enable = true;
  rofi.enable = true;
  dunst.enable = true;
  wezterm.enable = true;
  autorandr.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  texlive.enable = true;

  disabledModules = [
    "services/dunst.nix" # disable upstream to customize icon path and categories
  ];

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

  home = {
    username = "dap";
    homeDirectory = "/home/dap";
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      nixfmt
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
    ];

    file.".config/greenclip.toml".text = ''
      [greenclip]
      blacklisted_applications = []
      enable_image_support = true
      history_file = "/home/dap/.cache/greenclip.history"
      image_cache_directory = "/tmp/greenclip"
      max_history_length = 50
      max_selection_size_bytes = 0
      static_history = [""]
      trim_space_from_selection = true
      use_primary_selection_as_input = false
    '';
  };

  # Add stuff for your user as you see fit:
  #programs.neovim.enable = true;
  programs.feh.enable = true;

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
      init = { defaultBranch = "main"; };  
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

  gtk = {
    enable = true;
    iconTheme.name = "Gruvbox-Plus-Dark";
    cursorTheme.package = pkgs.gnome.adwaita-icon-theme;
    cursorTheme.name = "Adwaita";
    cursorTheme.size = 24;
    theme = {
      package = pkgs.gruvbox-gtk-theme;
      name = "Gruvbox-Dark-BL";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
