{
  config,
  pkgs,
  lib,
  ...
}:

{

  options = {
    i3.colemak.enable = lib.mkEnableOption "Enables i3wm colemak (docked) keybindings";
  };

  config = lib.mkIf config.i3.colemak.enable {

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
          "${modifier}+n" = "focus left";
          "${modifier}+e" = "focus down";
          "${modifier}+i" = "focus up";
          "${modifier}+o" = "focus right";

          # Move
          "${modifier}+Shift+n" = "move left";
          "${modifier}+Shift+e" = "move down";
          "${modifier}+Shift+i" = "move up";
          "${modifier}+Shift+o" = "move right";

          #Layout
          "${modifier}+s" = "layout toggle splith tabbed";
          "${modifier}+t" = "fullscreen toggle";

          # Workspaces
          "${modifier}+q" = "workspace number 1";
          "${modifier}+w" = "workspace number 2";
          "${modifier}+f" = "workspace number 3";
          "${modifier}+p" = "workspace number 4";
          "${modifier}+b" = "workspace number 5";
          "${modifier}+j" = "workspace number 6";
          "${modifier}+l" = "workspace number 7";
          "${modifier}+u" = "workspace number 8";
          "${modifier}+y" = "workspace number 9";
          "${modifier}+semicolon" = "workspace number 10";

          "${modifier}+Shift+q" = "move container to workspace number 1";
          "${modifier}+Shift+w" = "move container to workspace number 2";
          "${modifier}+Shift+f" = "move container to workspace number 3";
          "${modifier}+Shift+p" = "move container to workspace number 4";
          "${modifier}+Shift+b" = "move container to workspace number 5";
          "${modifier}+Shift+j" = "move container to workspace number 6";
          "${modifier}+Shift+l" = "move container to workspace number 7";
          "${modifier}+Shift+u" = "move container to workspace number 8";
          "${modifier}+Shift+y" = "move container to workspace number 9";
          "${modifier}+Shift+semicolon" = "move container to workspace number 10";

          "${modifier}+Shift+a" = "kill";

          "${modifier}+d" = "exec --no-startup-id rofi -show combi -modes combi -combi-modes drun#ssh#window -show-icons -combi-hide-mode-prefix";

          "${modifier}+period" = "exec xflock4";
          "${modifier}+c" = ''exec --no-startup-id rofi -modi "clipboard:greenclip print" -show clipboard'';
        };
      };
    };
  };
}
