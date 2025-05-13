{
config,
pkgs,
lib,
...
}:
{

  options = {
    hyprpaper.enable = lib.mkEnableOption "Enables HyprPaper";
  };

  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [
          "/etc/nixos/assets/stanislausnationalforest_left.jpg"
          "/etc/nixos/assets/stanislausnationalforest_right.jpg"
        ];

        wallpaper = [
        "DP-6,/etc/nixos/assets/stanislausnationalforest_left.jpg"
        "HDMI-A-1,/etc/nixos/assets/stanislausnationalforest_right.jpg"
        "eDP-1,/etc/nixos/assets/stanislausnationalforest_right.jpg"
        ];
      };
    };
    wayland.windowManager.hyprland.settings.exec-once = [
      "uwsm app -- ${pkgs.hyprpaper}/bin/hyprpaper"
    ];
  };
}
