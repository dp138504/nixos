{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      # Variables
      "$terminal" = "wezterm";
      "$mod" = "SUPER";

      # Mouse Bindings
      bindm = [
        "$mod, mouse:272, movewindow"
      ];


      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        '', switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
        '', switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, auto-right, 1"''
      ];

      # Main bindings
      bind = [
        # General
        "$mod, return, exec, $terminal"
        "$mod SHIFT, a, killactive"
        "$mod, period, exec, ${pkgs.hyprlock}/bin/hyprlock"

        # Screen focus
        #          "$mod, v, togglefloating"
        #          "$mod, u, focusurgentorlast"
        #          "$mod, tab, focuscurrentorlast"
        "$mod, t, fullscreen, 1"

        # Screen resize
        "$mod CTRL, n, resizeactive, -20 0"
        "$mod CTRL, o, resizeactive, 20 0"
        "$mod CTRL, e, resizeactive, 0 -20"
        "$mod CTRL, i, resizeactive, 0 20"

        # Workspaces
        "$mod, q, workspace, 1"
        "$mod, w, workspace, 2"
        "$mod, f, workspace, 3"
        "$mod, p, workspace, 4"
        "$mod, b, workspace, 5"
        "$mod, j, workspace, 6"
        "$mod, l, workspace, 7"
        "$mod, u, workspace, 8"
        "$mod, y, workspace, 9"
        "$mod, semicolon, workspace, 10"
        "$mod, s, togglespecialworkspace, scratch"

        # Move to workspaces
        "$mod SHIFT, q, movetoworkspace,1"
        "$mod SHIFT, w, movetoworkspace,2"
        "$mod SHIFT, f, movetoworkspace,3"
        "$mod SHIFT, p, movetoworkspace,4"
        "$mod SHIFT, b, movetoworkspace,5"
        "$mod SHIFT, j, movetoworkspace,6"
        "$mod SHIFT, l, movetoworkspace,7"
        "$mod SHIFT, u, movetoworkspace,8"
        "$mod SHIFT, y, movetoworkspace,9"
        "$mod SHIFT, semicolon, movetoworkspace,10"
        "$mod SHIFT, s, movetoworkspace, special:scratch"

        # Navigation
        "$mod, n, movefocus, l"
        "$mod, o, movefocus, r"
        "$mod, i, movefocus, u"
        "$mod, e, movefocus, d"

        # Applications
        "$mod SHIFT, n, exec, zen"
        ''$mod SHIFT, e, exec, $terminal --config "window_close_confirmation='NeverPrompt'" -e yazi''
        "$mod SHIFT, o, exec, ${pkgs.obsidian}/bin/obsidian"
        "$mod, d, exec, pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel"
        "$mod, tab, overview:toggle"
        # Clipboard
        "$mod, V, exec,  $terminal start --class clipse -e 'clipse'"
      ];
    };
  };
}
