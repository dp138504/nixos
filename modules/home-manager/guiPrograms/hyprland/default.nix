{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.home.hyprland;
in
{

  options = {
    profiles.home.hyprland.enable = lib.mkEnableOption "Enables hyprland and supporting applications";
  };

  imports = [
    ./waybar
    ./hyprlock
    ./hyprpaper
    ./swaync
    ./fuzzel
    ./kanshi

    ./plugins.nix
    ./bindings-colemak.nix
    ./bindings-qwerty.nix
    ./rules.nix
  ];

  config = lib.mkIf cfg.enable {

    ########################################
    # Supporting applications for Hyprland #
    ########################################

    waybar.enable = true; # Status Bar
    swaync.enable = true; # Notification Center
    hyprlock.enable = true; # Screen Locker/Idle daemon
    hyprpaper.enable = true; # Wallpaper Daemon
    fuzzel.enable = true; # Application Launcher

    # Tell HyprLand to use discrete GPU first
    home.file.".config/uwsm/env-hyprland" = {
      text = ''
        export AQ_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"
      '';
    };

#    home.file.".config/uwsm/env" = {
#      text = ''
#        export GBM_BACKEND=nvidia-drm
#        export __GLX_VENDOR_LIBRARY_NAME=nvidia
#        export __GL_GSYNC_ALLOWED=1
#        export LIBVA_DRIVER_NAME=nvidia
#      '';
#    };

    home = {
      packages = with pkgs; [
        hyprpolkitagent
        wl-clipboard
        networkmanagerapplet
        grimblast # Screenshot tool
        clipse # Clipboard manager
        yazi # TUI file browser
        nemo # GUI file browser
        pwvucontrol
        (writeShellApplication { # Toggleable hyprland bindings.
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

    ########################################
    # Main Configuration #
    ########################################

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
   #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      systemd.enable = false; # Launch with UWSM

      settings = {
        debug = {
          disable_logs = false;
        };
        general = {
          gaps_in = 6;
          gaps_out = 6;
          border_size = 2;
          layout = "dwindle";
          allow_tearing = true;
          resize_on_border = true;
        };

        decoration = {
          rounding = 5;
        };

        xwayland = {
          force_zero_scaling = true;
        };

#        monitor = [
#          "DP-6, 3840x2160@60, 0x0, 1.5"
#          "DP-7, 2560x1440@59.95, auto-right, 1"
##          "eDP-1, 2256x1504@60.00Hz, auto-right, 1"
#          "eDP-1, disable"
#        ];

        animation = [
          "specialWorkspace, 1, 8, default, slidevert"
        ];

        exec-once = [

          # Launch startup applications on specific workspaces
          "[workspace 5 silent] discord"
          "[workspace special:scratch silent] bitwarden"
          "[workspace special:scratch silent] ytmdesktop"
          "[workspace special:scratch silent] galculator"

          # Start various applications for desktop environment
          "clipse --listen"
          "uwsm app -- nm-applet"
          "blueman-tray"
          ''hyprctl setcursor "Capitaine Cursors (Gruvbox)" 32''
          "tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE \"$HYPRLAND_INSTANCE_SIGNATURE\""
          "systemctl --user start hyprpolkitagent"
        ];
      };

    };
  };
}
