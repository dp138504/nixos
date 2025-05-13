{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.home.hyprland;
in
{
  options = {
    profiles.home.hyprland.qwerty = lib.mkEnableOption "Enables hyprland qwerty (undocked) keybindings";
  };

  config = lib.mkIf cfg.qwerty {
    wayland.windowManager.hyprland = {
      settings = {
        # Variables
        "$terminal" = "wezterm";
        "$mod" = "SUPER";
  
        # Mouse Bindings
        bindm = [
          "$mod, mouse:272, movewindow"
        ];
  
  #      input = {
  #        drag_threshold = 10;
  #      };
  
  #      bindc = [
  #        "$mod, mouse:274, togglefloating"
  #      ];
  
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
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
          "$mod, f, fullscreen, 1"
  
          # Screen resize
          "$mod CTRL, j, resizeactive, -20 0"
          "$mod CTRL, k, resizeactive, 20 0"
          "$mod CTRL, l, resizeactive, 0 -20"
          "$mod CTRL, semicolon, resizeactive, 0 20"
  
          # Workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod, s, togglespecialworkspace, scratch"
  
          # Move to workspaces
          "$mod SHIFT, 1, movetoworkspace,1"
          "$mod SHIFT, 2, movetoworkspace,2"
          "$mod SHIFT, 3, movetoworkspace,3"
          "$mod SHIFT, 4, movetoworkspace,4"
          "$mod SHIFT, 5, movetoworkspace,5"
          "$mod SHIFT, 6, movetoworkspace,6"
          "$mod SHIFT, 7, movetoworkspace,7"
          "$mod SHIFT, 8, movetoworkspace,8"
          "$mod SHIFT, 9, movetoworkspace,9"
          "$mod SHIFT, 0, movetoworkspace,10"
          "$mod SHIFT, s, movetoworkspace, special:scratch"
  
          # Navigation
          "$mod, j, movefocus, l"
          "$mod, k, movefocus, r"
          "$mod, l, movefocus, u"
          "$mod, semicolon, movefocus, d"
  
          # Applications
          "$mod SHIFT, n, exec, zen"
          ''$mod SHIFT, e, exec, $terminal --config "window_close_confirmation='NeverPrompt'" -e yazi''
          "$mod SHIFT, o, exec, ${pkgs.obsidian}/bin/obsidian"
          "$mod, d, exec, pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel"
  #        "$mod, tab, overview:toggle"
          # Clipboard
          "$mod, V, exec,  $terminal start --class clipse -e 'clipse'"
        ];
      };
    };
  };
}
