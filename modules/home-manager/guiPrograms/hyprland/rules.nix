{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "1, monitor:DP-7"
      "2, monitor:DP-7"
      "3, monitor:DP-7"
      "4, monitor:DP-7"
      "5, monitor:DP-7"

      "6, monitor:DP-6"
      "7, monitor:DP-6"
      "8, monitor:DP-6"
      "9, monitor:DP-6"
      "10, monitor:DP-6"

      "11, monitor:eDP-1"
    ];
    windowrulev2 = [
      # Open Discord on 5
      "workspace 5, class:vesktop"

      # Fullscreen border color
      "bordercolor rgb(d65d0e), fullscreen:1"

      #Scratch workspace floating rule
      "float, workspace:name:special:scratch"

      "float, title:Picture-in-Picture"
      "size 880 497, title:Picture-in-Picture"

      "float, title:Extension.*"

      "float, class:Bitwarden"
      "move 3645 95, class:Bitwarden"
      "size 903 737, class:Bitwarden"

      "float, class: galculator"
      "move 4686 303, class:galculator"
      "size 600 323, class:galculator"

      "float, class:YouTube Music Desktop App"
      "move 3902 879, class:YouTube Music Desktop App"
      "size 1447 788, class: YouTube Music Desktop App"

      # Hide xwaylandvideobridge
      "opacity 0.0 override, class:^(xwaylandvideobridge)$"
      "noanim, class:^(xwaylandvideobridge)$"
      "noinitialfocus, class:^(xwaylandvideobridge)$"
      "maxsize 1 1, class:^(xwaylandvideobridge)$"
      "noblur, class:^(xwaylandvideobridge)$"
      "nofocus, class:^(xwaylandvideobridge)$"

      # Clipboard
      "float,class:(clipse)"
      "size 622 652,class:(clipse)"
      
      ''float, title:^Extension: \(Bitwarden Password Manager\).*''
    ];

  };
}
