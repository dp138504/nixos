{ pkgs, ... }:
{

  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprspace
      pkgs.hyprlandPlugins.hypr-dynamic-cursors
    ];

    settings = {
      plugin = {
        overview = {
          panelColor = "rgba(3c383698)";
          panelBorderColor = "rgb(282828)";
          workspaceActiveBorder = "rgb(98971a)";
          workspaceActiveBackground = "rgb(98971a)";
          workspaceInactiveBorder = "rgb(282828)";
          workspaceInactiveBackground = "rgb(282828)";
          dragAlpha = 0.4;

          panelHeight = 300;
          panelBorderWidth = 3;
          workspaceBorderSize = 2;
          centerAligned = true;
          affectStrut = false;
          exitOnClick = true;
          switchOnDrop = true;
          showNewWorkspace = false;

        };
        dynamic-cursors = {
          enabled = true;
          mode = "stretch";

          stretch = {
            limit = 3000;
            function = "quadratic";
          };
          shake = {
            enabled = true;
            nearest = 0;
            threshold = 6.0;
            base = 4.0;
            speed = 4.0;
            influence = 0.0;
            limit = 10.0;
            timeoute = 2000;
            effects = false;
          };
          hyprcursor = {
            nearest = 0;
            enabled = true;
            resolution = -1;
            fallback = "clientside";
          };
        };
      };

    };
  };
}
