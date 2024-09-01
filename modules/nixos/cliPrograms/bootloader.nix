{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.bootloader;
in
{
  options = {
    profiles.bootloader = {
      enable = lib.mkEnableOption "Enable bootloader customizations";

      systemd-boot = lib.mkOption {
        description = "Enables systemd bootloader";
        default = true;
        type = lib.types.bool;
      };

      grub = lib.mkOption {
        description = "Enables GRUB2 bootloader";
        default = false;
        type = lib.types.bool;
      };

      graphical = lib.mkOption {
        description = "Enables plymouth graphical boot";
        default = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    boot.loader = {
      systemd-boot = lib.mkIf (cfg.systemd-boot) {
        enable = true;
        configurationLimit = 5;
      };
      grub = lib.mkIf (cfg.grub) {
        # TODO: Actually test this
        enable = true;
      };
    };

    boot.plymouth = lib.mkIf (cfg.graphical) {
      enable = true; # Graphical boot
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [
            "angular"
            "angular_alt"
            "connect"
            "deus_ex"
            "green_blocks"
            "hexagon_dots_alt"
          ];
        })
      ];
      theme = "hexagon_dots_alt";
    };
  };
}
