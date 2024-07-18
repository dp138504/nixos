# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  inputs,
  outputs,
  pkgs,
  nix-colors,
  ...
}:

{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule
  ];

  wezterm.enable = true;
  zsh.enable = true;
  tmux.enable = true;

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

  xdg.mime.enable = true;

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
      unzip
      gnupg
      nvim-pkg
    ];
  };

  # Add stuff for your user as you see fit:
  programs.vscode = {
    enable = true;
  };

  programs.zsh = {
    shellAliases = {
      update = "home-manager switch --flake ~/src/nixos/#dap@dylan-acenet";
      vim = "nvim";
    };
    oh-my-zsh = {
      extraConfig = ''
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.colorScheme.palette.base04}"
      '';
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
