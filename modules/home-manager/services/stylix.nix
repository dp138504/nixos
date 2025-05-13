{ pkgs, ... }:{

stylix = {
  enable = true;
  polarity = "dark";

  image = ../../../assets/stanislausnationalforest_right.jpg;

  base16Scheme = {
    base00 = "#282828"; # Default Background
    base01 = "#373737"; # Lighter Background (Used for status bars, line number)
    base02 = "#504945"; # Selection Background
    base03 = "#665c54"; # Comments, Invisibles, Line Highlighting
    base04 = "#5a5a5e"; # Dark Foreground (Used for status bars)
    base05 = "#989899"; # Default Foreground, Caret, Delimiters, Operators
    base06 = "#ebdbb2"; # Light Foreground (Not often used)
    base07 = "#fbf1c7"; # Light Background (Not often used)
    base08 = "#fb4934"; # red
    base09 = "#fe8019"; # yellow
    base0A = "#458588"; # blue
    base0B = "#b8bb26"; # green
    base0C = "#8ec07c"; # aqua
    base0D = "#b8bb26"; # accent green
    base0E = "#d3869b"; # pink
    base0F = "#d65d0e"; # brown
  }; 
  targets.gtk.enable = true;
  targets.kde.enable = true;
  targets.waybar.enable = false;

  cursor = {
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Gruvbox)";
    size = 32;
  };
  
  fonts = {
    serif = {
      package = pkgs.google-fonts;
      name = "EB Garamond";
    };

    sansSerif = {
      package = pkgs.google-fonts;
      name = "Overpass";
    };

    monospace = {
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ;
      name = "JetBrainsMonoNF";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    
    sizes = {
      applications = 10;
      terminal = 10;
      desktop  = 12;
      popups   = 12;
    };
  };

  iconTheme = {
    enable = true;
    package = pkgs.gruvbox-plus-icons;
    dark = "Gruvbox-Plus-Dark";
    light = "Gruvbox-Plus-Light";
  };

};

gtk.enable = true;

}
