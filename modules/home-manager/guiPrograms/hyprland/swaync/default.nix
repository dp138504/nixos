{
  config,
    pkgs,
    lib,
    ...
}:

let
swayncConfig = {
  "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
  positionX = "right";
  positionY = "top";
  control-center-margin-top = 10;
  control-center-margin-bottom = 10;
  control-center-margin-right = 10;
  control-center-margin-left = 10;
  widgets = [
    "dnd"
      "title"
      "notifications"
  ];
  widget-config = {
    dnd = {
      text = "Do not disturb";
    };
    title = {
      text = "Notifications";
      clear-all-button = true;
      button-text = "󰆴";
    };
  };
};
in
{
  options = {
    swaync.enable = lib.mkEnableOption "Enables Sway Notification Center";
  };

  config = lib.mkIf config.swaync.enable {
    home = {
      packages = [ pkgs.swaynotificationcenter ];
      file = {
        ".config/swaync/config.json".text = builtins.toJSON swayncConfig;
        ".config/swaync/style.css".source = ./style.css;
      };
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [ "swaync" ];
      layerrule = [
        "animation slide right, swaync-control-center"
        "animation slide right, swaync-notification-window"
      ];
    };
  };
}
