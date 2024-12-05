{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.home.i3;
in
{

  options = {
    profiles.home.i3.enable = lib.mkEnableOption "Enables i3wm and supporting applications";
  };

  imports = [
    ./i3_qwerty.nix
    ./i3_colemak.nix
  ];

  config = lib.mkIf cfg.enable {

    ######################################
    ## Supporting applications for i3wm ##
    ######################################

    ## Preferred Bar ##
    polybar.enable = true;

    ## Dmenu style application launcher ##
    rofi.enable = true;

    ## Dunst notification daemon ##
    dunst.enable = true;

    ## Compositor ##
    services.picom = {
      enable = true;
      vSync = true;
    };

    ## Lightweight image viewer/background setter ##
    programs.feh.enable = true;

    ## GTK themeing for custom icon pack ##
    gtk = {
      enable = true;
      iconTheme.name = "Gruvbox-Plus-Dark";
      cursorTheme.package = pkgs.adwaita-icon-theme;
      cursorTheme.name = "Adwaita";
      cursorTheme.size = 24;
      theme = {
        package = pkgs.gruvbox-gtk-theme;
        name = "Gruvbox-Dark";
      };
    };

    #############################
    ## Main i3wm configuration ##
    #############################
    xsession.windowManager.i3 = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "wezterm";

        fonts = {
          names = [ "JetBrainsMono Nerd Font Mono" ];
          size = 12.0;
        };

        window = {
          border = 1;
          titlebar = false;
        };

        gaps = {
          inner = 6;
          outer = 3;
        };

        colors = {
          focused = {
            border = "#${config.colorScheme.palette.base0B}";
            background = "#${config.colorScheme.palette.base0B}";
            text = "#${config.colorScheme.palette.base0B}";
            indicator = "#${config.colorScheme.palette.base0D}";
            childBorder = "#${config.colorScheme.palette.base0B}";
          };
          unfocused = {
            border = "#${config.colorScheme.palette.base02}";
            background = "#${config.colorScheme.palette.base02}";
            text = "#${config.colorScheme.palette.base00}";
            indicator = "#${config.colorScheme.palette.base0D}";
            childBorder = "#${config.colorScheme.palette.base02}";
          };
          focusedInactive = {
            border = "#${config.colorScheme.palette.base02}";
            background = "#${config.colorScheme.palette.base02}";
            text = "#${config.colorScheme.palette.base00}";
            indicator = "#${config.colorScheme.palette.base0D}";
            childBorder = "#${config.colorScheme.palette.base02}";
          };
          urgent = {
            border = "#${config.colorScheme.palette.base08}";
            background = "#${config.colorScheme.palette.base08}";
            text = "#${config.colorScheme.palette.base08}";
            indicator = "#${config.colorScheme.palette.base08}";
            childBorder = "#${config.colorScheme.palette.base08}";
          };
        };

        startup = [
          {
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }
          {
            command = "i3-msg workspace 1";
            always = true;
            notification = false;
          }
          {
            command = "greenclip daemon > /dev/null";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.autorandr}/bin/autorandr -c";
            always = true;
            notification = false;
          }
          {
            command = "sleep 3; ${pkgs.feh}/bin/feh --bg-scale /etc/nixos/assets/background_2256x1504.jpg --no-fehbg";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.xfce.xfce4-screensaver}/bin/xfce4-screensaver";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.xfce.xfce4-power-manager}/bin/xfce4-power-manager";
            always = true;
            notification = false;
          }
        ];

        bars = [ ]; # Disable i3bar for polybar use
      };
    };
  };
}
