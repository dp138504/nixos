{ config, pkgs, lib, ... }:

{
  services.polybar.enable = true;
  services.polybar.script = "polybar top &";
  services.polybar.package = pkgs.polybar.override {
    i3Support = true;
    alsaSupport = true;
    iwSupport = true;
    githubSupport = true;
  };
  services.polybar.settings = {
    "settings" = {
      screenchange-reload = true;
      pseudo-transparency = true;
    };
    "bar/top" = {
      background = "#${config.colorScheme.palette.base00}";
      foreground = "#${config.colorScheme.palette.base06}";
      width = "100%";
      height = "24pt";
      radius = 0;
      enable-ipc = true;
      modules-left = "i3 xwindow";
      modules-right =
        "cpu memory lan wlan battery alsa backlight tray powermenu";
      modules-center = "date";
      font-0 = ''"JetBrainsMono NF;2"'';
      font-1 = ''"Noto Color Emoji:scale=10; 2"'';
      line-size = "3pt";
      border-size = "4pt";
      border-color = "#${config.colorScheme.palette.base00}";
      padding-left = 0;
      padding-right = 1;
      module-margin = 1;
      separator = "|";
    };
    "module/xwindow" = {
      type = "internal/xwindow";
      label = "%title:0:60:...%";
    };
    "module/tray" = {
      type = "internal/tray";
      format = "<tray>";
      tray-padding = 2;
    };
    "module/i3" = {
      type = "internal/i3";
      show-urgent = true;
      label-mode = "%mode%";
      label-mode-padding = 1;
      label-mode-background = "#${config.colorScheme.palette.base08}";
      label-focused = "%index%";
      label-focused-background = "#${config.colorScheme.palette.base00}";
      label-focused-underline = "#${config.colorScheme.palette.base0B}";
      label-focused-padding = 1;
      label-unfocused = "%index%";
      label-unfocused-padding = 1;
      label-urgent = "%index%";
      label-urgent-background = "#${config.colorScheme.palette.base08}";
      label-urgent-padding = 1;
      label-empty = "%index%";
      label-empty-foreground = "#${config.colorScheme.palette.base02}";
      label-empty-padding = 1;
      label-separator = "|";
      label-separator-padding = 0;
      label-separator-foreground = "#${config.colorScheme.palette.base03}";
      label-visible = "%index%";
      label-visible-padding = 1;
      label-visible-background = "#${config.colorScheme.palette.base00}";
      label-visible-underline = "#${config.colorScheme.palette.base02}";
    };
    "module/date" = {
      type = "internal/date";
      interval = 1.0;
      date = "%H:%M:%S";
      date-alt = "%d %b %H:%M:%S";
    };
    "module/backlight" = {
      type = "internal/backlight";
      card = "intel_backlight";
      format = "<ramp> <label>";
      label = "%percentage%%";
      ramp = [ "🌑" "🌒" "🌓" "🌔" "🌕" ];
    };
    "module/alsa" = {
      type = "internal/alsa";
      master-soundcard = "default";
      master-mixer = "Master";
      mapped = false;
      format-volume = "<ramp-volume> <label-volume>";
      label-muted = "󰝟";
      label-volume = "%percentage%%";
      ramp.volume = [ "󰕿" "󰖀" "󰕾" ];
    };
    "module/battery" = {
      type = "internal/battery";
      full-at = 100;
      low-at = 15;
      battery = "BAT1";
      adapter = "ACAD";
      ramp.capacity = [ "" "" "" "" "" ];
      animation.charging = [ "" "" "" "" "" ];
      animation-charging-framerate = 750;
      format = {
        discharging = "<ramp-capacity>  <label-discharging>";
        charging = "<animation-charging> <label-charging>";
        low = "<animation-low> <label-low>";
        full = "<ramp-capacity>  100%";
      };
      label = {
        charging = "  %percentage%%";
        discharging = "%time%";
        low = " %time%";
      };
      time-format = "%H:%M";
      animation.low = [ "" "" ];
      animation-low-framerate = 750;
    };
    "module/wlan" = {
      type = "internal/network";
      interval = 5;
      format-connected = "<label-connected>";
      format-disconnected = "%ifname% disconnected";
      interface-type = "wireless";
      label-connected = "󰘊 %essid% %local_ip%";
    };
    "module/lan" = {
      type = "internal/network";
      interval = 5;
      format-connected = "<label-connected>";
      format-disconnected = "%ifname% disconnected";
      interface-type = "wired";
      label-connected = "󰌗 %local_ip%";
    };
    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      format-prefix = " ";
      label = "%percentage_used%%";
    };
    "module/cpu" = {
      type = "internal/cpu";
      interval = 2;
      format-prefix = " ";
      label = "%percentage%%";
    };
    "module/powermenu" = {
      type = "custom/menu";

      expand-right = true;

      format-spacing = 1;

      label-open = "";
      label-open-foreground = "#${config.colorScheme.palette.base06}";
      label-close = "";
      label-close-padding-right = "5pt";
      label-close-foreground = "#${config.colorScheme.palette.base06}";
      label-separator = "|";
      label-separator-foreground = "#${config.colorScheme.palette.base03}";

      menu-0-0 = "Reboot";
      menu-0-0-exec = "#powermenu.open.1";
      menu-0-0-foreground = "#${config.colorScheme.palette.base08}";

      menu-0-1 = "Power Off";
      menu-0-1-exec = "#powermenu.open.2";
      menu-0-1-foreground = "#${config.colorScheme.palette.base08}";

      menu-0-2 = "Hibernate";
      menu-0-2-exec = "#powermenu.open.3";
      menu-0-2-foreground = "#${config.colorScheme.palette.base08}";

      menu-0-3 = "Log Out";
      menu-0-3-exec = "#powermenu.open.4";
      menu-0-3-foreground = "#${config.colorScheme.palette.base0A}";

      menu-1-0 = "󰌍";
      menu-1-0-padding-right = "5pt";
      menu-1-0-exec = "#powermenu.open.0";
      menu-1-0-foreground = "#${config.colorScheme.palette.base06}";
      menu-1-1 = "Reboot";
      menu-1-1-exec = "${pkgs.systemd}/bin/systemctl reboot";
      menu-1-1-foreground = "#${config.colorScheme.palette.base08}";

      menu-2-0 = "󰌍";
      menu-2-0-padding-right = "5pt";
      menu-2-0-exec = "#powermenu.open.0";
      menu-2-0-foreground = "#${config.colorScheme.palette.base06}";
      menu-2-1 = "Power Off";
      menu-2-1-exec = "${pkgs.systemd}/bin/systemctl poweroff";
      menu-2-1-foreground = "#${config.colorScheme.palette.base08}";

      menu-3-0 = "󰌍";
      menu-3-0-padding-right = "5pt";
      menu-3-0-exec = "#powermenu.open.0";
      menu-3-0-foreground = "#${config.colorScheme.palette.base06}";
      menu-3-1 = "Hibernate";
      menu-3-1-exec = "${pkgs.systemd}/bin/systemctl hibernate";
      menu-3-1-foreground = "#${config.colorScheme.palette.base08}";

      menu-4-0 = "󰌍";
      menu-4-0-padding-right = "5pt";
      menu-4-0-exec = "#powermenu.open.0";
      menu-4-0-foreground = "#${config.colorScheme.palette.base06}";
      menu-4-1 = "Log Out";
      #menu-4-1-exec = "${pkgs.i3}/bin/i3-msg exit";
      menu-4-1-exec = "${pkgs.xfce.xfce4-session}/bin/xfce4-session-logout --logout";
      menu-4-1-foreground = "#${config.colorScheme.palette.base0A}";
    };
  };
}
