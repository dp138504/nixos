{
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

    ./plugins.nix
    ./bindings.nix
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

    home = {
      packages = with pkgs; [
        hyprpolkitagent
        wl-clipboard
        networkmanagerapplet
        clipse # Clipboard manager
        yazi # TUI file browser
        nemo # GUI file browser
      ];
    };

    ########################################
    # Main Configuration #
    ########################################

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # Launch with UWSM

      settings = {
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

        monitor = [
          "DP-6, 3840x2160@60, 0x0, 1.5"
          "DP-7, 2560x1440@59.95, auto-right, 1"
          "eDP-1, 2256x1504@60.00Hz, auto-right, 1"
        ];

        animation = [
          "specialWorkspace, 1, 8, default, slidevert"
        ];

        exec-once = [
          "[workspace 5 silent] discord"
          "[workspace special:scratch silent] bitwarden"
          "[workspace special:scratch silent] ytmdesktop"
          "[workspace special:scratch silent] galculator"
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
