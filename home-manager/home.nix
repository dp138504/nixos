# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, nix-colors, ... }:

{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./i3.nix
    ./polybar.nix
    ./rofi.nix
    ./modules/services/dunst.nix
  ];
  
  disabledModules = [
    "services/dunst.nix" # disable upstream to customize icon path and categories
  ];

  # System theme
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  programs = {
    kitty = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font Mono";
      font.size = 12;
      settings = {
        background_opacity = "0.9";
	foreground = "#${config.colorScheme.colors.base06}";
        background = "#${config.colorScheme.colors.base00}";
        color0 = "#${config.colorScheme.colors.base00}";
        color8 = "#${config.colorScheme.colors.base02}";
        color1 = "#${config.colorScheme.colors.base08}";
        color9 = "#${config.colorScheme.colors.base08}";
        color2 = "#${config.colorScheme.colors.base0B}";
        color10 = "#${config.colorScheme.colors.base0B}";
        color3 = "#${config.colorScheme.colors.base0A}";
        color11 = "#${config.colorScheme.colors.base0A}";
        color4 = "#${config.colorScheme.colors.base0D}";
        color12 = "#${config.colorScheme.colors.base0D}";
        color5 = "#${config.colorScheme.colors.base0E}";
        color13 = "#${config.colorScheme.colors.base0E}";
        color6 = "#${config.colorScheme.colors.base0C}";
        color14 = "#${config.colorScheme.colors.base0C}";
        color7 = "#${config.colorScheme.colors.base06}";
        color15 = "#${config.colorScheme.colors.base06}";
      };
    };
  };

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      outputs.overlays.unstable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
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

  fonts.fontconfig.enable = true;

  home = {
    username = "dap";
    homeDirectory = "/home/dap";
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      nixfmt
      bitwarden
      tmux
      vivaldi
      tree
      slack
      haskellPackages.greenclip # Rofi clipboard manager
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
  programs.neovim.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "half-life";
      plugins = [ "git" "tmux" "sudo" ];
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/#fw13-nixos";
      update = "home-manager switch --flake /etc/nixos/#dap@fw13-nixos";
      vim = "nvim";
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "pitts.dylan@gmail.com";
    userName = "Dylan A. Pitts";
  };
  programs.feh.enable = true;
  services.dunst.enable = true;
  services.dunst.iconTheme = {
    package = pkgs.gruvbox-plus-icons-pack;
    name = "Gruvbox-Plus-Dark";
    size = "24";
  };
  services.dunst.additionalCategories = [ "panel" ];
  services.dunst.settings = {
    global = {
      font = "JetBrainsMono NFM 12";
      markup = "full";
      format = ''<b>%s</b>\n%b'';
      sort = true;
      indicate_hidden = true;
      alignment = "left";
      show_age_threshold = 60;
      word_wrap = true;
      ignore_newline = false;
      #geometry = "200x5-6+30";
      width = 256;
      origin = "top-right";
      offset = "10x51";
      transparency = 16;
      idle_threshold = 120;
      monitor = 0;
      follow = "mouse";
      sticky_history = true;
      line_height = 0;
      separator_height = 2;
      padding = 8;
      horizontal_padding = 8;
      separator_color = "#${config.colorScheme.colors.base02}";
      frame_width = 2;
      frame_color = "#${config.colorScheme.colors.base0B}";
      icon_position = "left";
      close = "ctrl+space";
      close_all = "ctrl+shift+space";
      history = "ctrl+grave";
      context = "ctrl+shift+period";
#      enable_recursive_icon_lookup = true;
    };
    urgency_low = {
      background = "#${config.colorScheme.colors.base00}";
      foreground = "#${config.colorScheme.colors.base03}";
      timeout = 5;
    };
    urgency_normal = {
      background = "#${config.colorScheme.colors.base00}";
      foreground = "#${config.colorScheme.colors.base06}";
      timeout = 20;
    };
    urgency_critical = {
      background = "#${config.colorScheme.colors.base00}";
      foreground = "#${config.colorScheme.colors.base06}";
      frame_color = "#${config.colorScheme.colors.base08}";
      timeout = 0;
    };
  };

  services.betterlockscreen = {
    enable = true;
    package = pkgs.unstable.betterlockscreen;
    inactiveInterval = 5;
    arguments = [ "dimblur --off 120" ];
  };

  services.picom.enable = true;
  services.picom.vSync = true;

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
  home.stateVersion = "23.05";
}
