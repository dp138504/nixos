{
  config,
    pkgs,
    lib,
    ...
}:
{
  options = {
    hyprlock.enable = lib.mkEnableOption "Enables HyprLock";
  };

  config = lib.mkIf config.hyprlock.enable {

    systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";

    programs.hyprlock = {
      enable = true;
      importantPrefixes = [
        "$font"
        "$textAlpha"
        "$accentAlpha"
      ];
      settings = {
        "$font" = "JetBrains Mono Nerd Font";
        "$textAlpha" = "989899";
        "$accentAlpha" = "98971a";
        general = {
          no_fade_in = true;
          no_fade_out = true;
          hide_cursor = false;
          grace = 0;
          disable_loading_bar = true;
        };
        background = {
          monitor = "";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        };
        
        label = [
          {
            monitor = "";
            font_family = "$font";
            text = "$TIME";
            color = "rgb($textAlpha)";
            font_size = 90;
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            font_family = "$font";
            text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
            color = "rgb($textAlpha)";
            font_size = 25;
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];
        image = {
          monitor = "";
          path = "$HOME/.face";
          size = 100;
          border_color = "rgb(665c54)";
          position = "0, 75";
          halign = "center";
          valign = "center";
        };

        input-field = {
          monitor = "";
          font_family = "$font";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        #{
        #  timeout = 1800;
        #  on-timeout = "loginctl suspend";
        #}
        ];
      };
    };
  };
}
