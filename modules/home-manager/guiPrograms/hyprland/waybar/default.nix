{
  config,
  pkgs,
  lib,
  ...
}:

{

  options = {
    waybar.enable = lib.mkEnableOption "Enables Waybar";
  };

  config = lib.mkIf config.waybar.enable {

    home.packages = with pkgs; [
      brightnessctl
      pipewire
      wireplumber
      rofi-wayland
      lm_sensors
      playerctl
    ];

wayland.windowManager.hyprland.settings.exec-once = [ "uwsm app -- waybar" ];

    programs.waybar = {
      enable = true;
      systemd.enable = false;
      style = ./style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          mode = "dock";
          height = 39;
          spacing = 4;
          reload_style_on_change = true;
          gtk-layer-shell = true;

          modules-left = [
            "hyprland/workspaces"
            "cava"
          ];

          modules-center = [
            "hyprland/window"
          ];

          modules-right = [
            "mpris"
            "idle_inhibitor"
            "group/hardware"
            "wireplumber"
            "backlight"
            "clock"
            "battery"
            "tray"
            "group/power"
            "custom/notifications"
          ];

          # Modules configuration
          "hyprland/workspaces" = {
            all-outputs = false;
            warp-on-scroll = false;
            format = "{icon}";
            persistent-workspaces = {
              DP-6 = [
                6
                7
                8
                9
                10
              ];
              DP-7 = [
                1
                2
                3
                4
                5
              ];
            };
            format-icons = {
              "1" = "󰈹";
              "2" = "";
              "3" = "";
              "4" = "󰠮";
              "5" = " ";
              "6" = "";
              "7" = "";
              "8" = "";
              "9" = "";
              "10" = "";
            };
            #        "format-icons": {
            #            "1": ""
            #            "2": ""
            #            "3": ""
            #            "4": ""
            #            "5": ""
            #            "9": ""
            #            "10": ""
            #        }
          };

          "hyprland/window" = {
            format = "{title}";
            max-length = 40;
            separate-outputs = true;
          };

          "cava" = {
            framerate = 30;
            autosens = 1;
            bars = 14;
            lower_cutoff_freq = 50;
            higher_cutoff_freq = 10000;
            method = "pipewire";
            source = "auto";
            stereo = true;
            bar_delimiter = 0;
            noise_reduction = 0.77;
            input_delay = 2;
            hide_on_silence = true;
            format-icons = [
              "▁"
              "▂"
              "▃"
              "▄"
              "▅"
              "▆"
              "▇"
              "█"
            ];
            actions = {
              on-click-right = "mode";
            };
          };

          "mpris" = {
            format = " {status_icon} {dynamic}";
            interval = 1;
            dynamic-len = 40;
            status-icons = {
              playing = "▶";
              paused = "⏸";
              stopped = "";
            };
            dynamic-order = [
              "title"
              "artist"
            ];
            ignored-players = [ "firefox" ];
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";

            };
          };

          "tray" = {
            icon-size = 24;
            spacing = 1;
          };

          "load" = {
            format = " {}";
          };

          "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };

          "group/hardware" = {
            orientation = "inherit";
            modules = [ "cpu" "temperature" "memory" ];
          };

          "cpu" = {
            format = " {usage}%";
            tooltip = false;
          };

          "memory" = {
            format = " {}%";
          };

          "temperature" = {
            thermal-zone = 12;
            critical-threshold = 80;
            format = "{icon} {temperatureC}°C";
            format-icons = [
              ""
              ""
              ""
            ];
          };

          "backlight" = {
            format = "{icon} {percent}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };

          "battery" = {
            states = {
              warning = 15;
              critical = 5;
            };
            format = "{icon} {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁼"
              "󰁾"
              "󰂀"
              "󰁹"
            ];
          };

          "wireplumber" = {
            scroll-step = 5; # % can be a float
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}% ";
            format-bluetooth-muted = " {icon}";
            format-muted = " ";
            format-icons = {
              headphone = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };

          "group/power" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 500;
              children-class = "not-power";
              transition-left-to-right = false;
            };
            modules = [
              "custom/power"
              "custom/quit"
              "custom/lock"
              "custom/reboot"
            ];
          };
          "custom/quit" = {
            format = "󰗼 ";
            tooltip = false;
            on-click = "uwsm stop";
          };
          "custom/lock" = {
            format = "󰍁 ";
            tooltip = false;
            on-click = "pidof hyprlock || hyprlock";
          };
          "custom/reboot" = {
            format = "󰜉 ";
            tooltip = false;
            on-click = "systemctl reboot";
          };
          "custom/power" = {
            format = " ";
            tooltip = false;
            on-click = "systemctl shutdown";
          };
          "custom/notifications" = {
            format = " ";
            tooltip = false;
            on-click = "swaync-client -t -sw";
          };
        };
      };
    };
  };
}
