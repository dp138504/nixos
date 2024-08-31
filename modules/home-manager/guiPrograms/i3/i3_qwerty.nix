{
  config,
  pkgs,
  lib,
  ...
}:

{

  options = {
    i3.qwerty.enable = lib.mkEnableOption "Enables i3wm qwerty (undocked) keybindings";
  };

  config = lib.mkIf config.i3.qwerty.enable {

    xsession.windowManager.i3 = {
      config = rec {
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
          "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
          "XF86MonBrightnessDown" = "exec xbacklight -dec 5";
          "XF86MonBrightnessUp" = "exec xbacklight -inc 5";

          # Focus
          "${modifier}+j" = "focus left";
          "${modifier}+k" = "focus down";
          "${modifier}+l" = "focus up";
          "${modifier}+semicolon" = "focus right";

          # Move
          "${modifier}+Shift+j" = "move left";
          "${modifier}+Shift+k" = "move down";
          "${modifier}+Shift+l" = "move up";
          "${modifier}+Shift+semicolon" = "move right";

          "${modifier}+d" = "exec --no-startup-id rofi -show combi -modes combi -combi-modes drun#ssh#window -show-icons -combi-hide-mode-prefix";

          #"${modifier}+l" = "exec betterlockscreen -l dimblur --off 120";
          "${modifier}+Escape" = "exec xflock4";
          "${modifier}+c" = ''exec --no-startup-id rofi -modi "clipboard:greenclip print" -show clipboard'';
        };
      };
    };
  };
}
