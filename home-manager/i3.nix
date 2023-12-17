{ config, pkgs, lib, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";

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
          border = "#${config.colorScheme.colors.base0B}";
          background = "#${config.colorScheme.colors.base0B}";
          text = "#${config.colorScheme.colors.base0B}";
          indicator = "#${config.colorScheme.colors.base0D}";
          childBorder = "#${config.colorScheme.colors.base0B}";
        };
        unfocused = {
          border = "#${config.colorScheme.colors.base02}";
          background = "#${config.colorScheme.colors.base02}";
          text = "#${config.colorScheme.colors.base00}";
          indicator = "#${config.colorScheme.colors.base0D}";
          childBorder = "#${config.colorScheme.colors.base02}";
        };
        focusedInactive = {
          border = "#${config.colorScheme.colors.base02}";
          background = "#${config.colorScheme.colors.base02}";
          text = "#${config.colorScheme.colors.base00}";
          indicator = "#${config.colorScheme.colors.base0D}";
          childBorder = "#${config.colorScheme.colors.base02}";
        };
        urgent = {
          border = "#${config.colorScheme.colors.base08}";
          background = "#${config.colorScheme.colors.base08}";
          text = "#${config.colorScheme.colors.base08}";
          indicator = "#${config.colorScheme.colors.base08}";
          childBorder = "#${config.colorScheme.colors.base08}";
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
#        {
#          command = "betterlockscreen -w";
#          always = true;
#          notification = false;
#        }
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
        #{
        #  command = "${pkgs.xfce.xfce4-settings}/libexec/xfce4-settings";
        #  always = true;
        #  notification = false;
        #}
        {
          command = "sleep 3; ${pkgs.feh}/bin/feh --bg-scale /etc/nixos/nixos/assets/background_2256x1504.jpg --no-fehbg";
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

      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
        "XF86MonBrightnessDown" = "exec xbacklight -dec 5";
        "XF86MonBrightnessUp" = "exec xbacklight -inc 5";

        # Focus
        "${modifier}+j" = "focus left";
        "${modifier}+k" = "focus down";
        #"${modifier}+l" = "focus up";
        "${modifier}+semicolon" = "focus right";

        # Move
        "${modifier}+Shift+j" = "move left";
        "${modifier}+Shift+k" = "move down";
        "${modifier}+Shift+l" = "move up";
        "${modifier}+Shift+semicolon" = "move right";

        "${modifier}+d" =
          "exec --no-startup-id rofi -show combi -modes combi -combi-modes drun#ssh#window -show-icons -combi-hide-mode-prefix";

        #"${modifier}+l" = "exec betterlockscreen -l dimblur --off 120";
        "${modifier}+l" = "exec xflock4";
        "${modifier}+c" = ''
          exec --no-startup-id rofi -modi "clipboard:greenclip print" -show clipboard'';
      };

      bars = [ ]; # Disable i3bar for polybar use
    };
  };
}
