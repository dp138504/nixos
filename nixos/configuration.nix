# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  boot.plymouth.enable = true;

  networking.hostName = "fw13-nixos"; # Define your hostname.

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  security.pam.services.lightdm.enableGnomeKeyring = true;

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = [ "nvidia" ];
    # Set keyboard layout
    layout = "us";
    xkbVariant = "";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;


    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeters.slick = {
          enable = true;
          theme = {
            name = "Gruvbox-Dark-BL";
            package = pkgs.gruvbox-gtk-theme; };
          iconTheme = {
            name = "Gruvbox-Plus-Dark";
            package = pkgs.gruvbox-plus-icons-pack; };
          cursorTheme = {
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme; };
        };
      };
    };

    desktopManager = {
      xterm.enable = false;
      budgie = { enable = true; };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3lock-color ];
    };
  };
  
#  services.autorandr = {
#    enable = true;
#    profiles = {
#      "docked" = {
#        fingerprint = {
#          DP-2 = "00ffffffffffff0006b3b127d7c801002f1b0104a53c227806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a029503020350056502100001a000000ff002341534f382b2f7a735a724c64000000fd001e9022de3b010a202020202020000000fc00524f4720504732373851520a20016a020312412309070183010000654b040001015a8700a0a0a03b503020350056502100001a5aa000a0a0a046503020350056502100001a6fc200a0a0a055503020350056502100001a22e50050a0a0675008203a0056502100001e1c2500a0a0a011503020350056502100001a0000000000000000000000000000000000000019";
#          DP-4 = "00ffffffffffff001e6d0777c09704000c200104b53c22789f3e31ae5047ac270c50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00283d878738010a202020202020000000fc004c472048445220344b0a20202001aa02031c7144900403012309070783010000e305c000e6060501605550023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e";
#          eDP-1-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
#        };
#        config = {
#          eDP-1-1.enable = false;
#          DP-2 = {
#            enable = true;
#            crtc = 0;
#            primary = true;
#            position = "3840x360";
#            mode = "2560x1440";
#            rate = "144.00";
#          };
#          DP-4 = {
#            enable = true;
#            crtc = 1;
#            position = "0x0";
#            mode = "3840x2160";
#            rate = "60.00";
#          };
#        };
#      };
#      "undocked" = {
#        fingerprint = {
#          DP-2 = "00ffffffffffff0006b3b127d7c801002f1b0104a53c227806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a029503020350056502100001a000000ff002341534f382b2f7a735a724c64000000fd001e9022de3b010a202020202020000000fc00524f4720504732373851520a20016a020312412309070183010000654b040001015a8700a0a0a03b503020350056502100001a5aa000a0a0a046503020350056502100001a6fc200a0a0a055503020350056502100001a22e50050a0a0675008203a0056502100001e1c2500a0a0a011503020350056502100001a0000000000000000000000000000000000000019";
#          DP-4 = "00ffffffffffff001e6d0777c09704000c200104b53c22789f3e31ae5047ac270c50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00283d878738010a202020202020000000fc004c472048445220344b0a20202001aa02031c7144900403012309070783010000e305c000e6060501605550023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e";
#          eDP-1 = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
#      };
#      config = {
#        DP-2.enable = false;
#        DP-4.enable = false;
#        eDP-1 = {
#          enable = true;
#          crtc = 0;
#          primary = true;
#          position = "0x0";
#          mode = "2256x1504";
#          rate = "60.00";
#        };
#      };
#    };
#  };
#  defaultTarget = "undocked";
#};

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true; # Thunderbolt daemon

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dap = {
    isNormalUser = true;
    description = "Dylan A Pitts";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ home-manager ];
  };

  # $ nix search nixpkgs#wget
  environment.systemPackages = with pkgs; [
    firefox # Default system browser
    vim # Text editor
    fprintd # Fingerprint reader daemon
    powertop # Power management monitor
    git
    gruvbox-plus-icons-pack # Gruvbox Icons
    gnome.seahorse # Gnome keyring management
  ];

  # Power management
  powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true;
    settings = { PCIE_ASPM_ON_BAT = "powersupersave"; };
  };

  systemd.targets.hybrid-sleep.enable = true;
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.lidSwitchExternalPower = "suspend";
  services.logind.extraConfig = ''
    IdleAction=hybrid-sleep
    IdleActionSec=1800s
  '';
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
    HibernateDelaySec=1800s
  '';

  programs.zsh.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # See the following for details 
  # https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true; # Not working with false
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:4:0:0";
    };
  };

  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      services.xserver.videoDrivers = lib.mkForce [ "i915" ];
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
