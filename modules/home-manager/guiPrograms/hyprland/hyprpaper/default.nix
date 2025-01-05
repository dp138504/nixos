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
          "/etc/nixos/assets/background_2256x1504.jpg"
        ];

        wallpaper = [
        "DP-6,/etc/nixos/assets/background_2256x1504.jpg"
        "DP-7,/etc/nixos/assets/background_2256x1504.jpg"
        "eDP-1,/etc/nixos/assets/background_2256x1504.jpg"
        ];
      };
    };
    wayland.windowManager.hyprland.settings.exec-once = [
      "uwsm app -- ${pkgs.hyprpaper}/bin/hyprpaper"
    ];
  };
}
