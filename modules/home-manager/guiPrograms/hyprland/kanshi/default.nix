{ ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "DP-6";
          status = "enable";
          mode = "3840x2160@60";
          position = "0,0";
          scale = 1.25;
          adaptiveSync = true;
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
          mode = "3840x2160@60";
          position = "3072,0";
          scale = 1.25;
          adaptiveSync = true;
        }
#        {
#          criteria = "DP-7";
#          status = "enable";
#          mode = "2560x1440@59.95";
#          position = "2560,0";
#          scale = 1.0;
#        }
        {
          criteria = "eDP-1";
          status = "disable";
        }
      ];
      profile.exec = "hyprctl reload";
    }
    {
      profile.name = "undocked";
      profile.outputs = [
       {
          criteria = "eDP-1";
          status = "enable";
          mode = "2256x1504@60";
          position = "0,0";
          scale = 1.333333;
        }
      ];
      profile.exec = "hyprctl reload";
    }
    ];
  };
}
