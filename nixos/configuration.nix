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
  boot.kernelParams = [ 
      "usbcore.autosuspend=300" # Suspend USB devices after 5 minutes (default is 2 seconds)
    ];
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

  #security.pam.services.lightdm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = [ "nvidia" ];
    # Set keyboard layout
    layout = "us";
    xkb.variant = "";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;


    displayManager = {
      defaultSession = "xfce+i3";
      sddm.settings = {
        X11 = {
          DisplayCommand = "${pkgs.autorandr}/bin/autorandr --load $(${pkgs.autorandr}/bin/autorandr --detected)";
        };
      };
      sddm.sugarCandyNix = {
        enable = true;
        settings = {
          Background = lib.cleanSource ./assets/background_2256x1504.jpg;
          ScreenWidth = 2256;
          ScreenHeight = 1504;
          FormPosition = "left";
          HaveFormBackground = true;
          PartialBlur = true;
          ForceHideCompletePassword = true; # Do not show any password characters
          HeaderText = "";
        };
      };
     # setupCommands = lib.mkAfter ''
     #   ${pkgs.autorandr}/bin/autorandr --load $(${pkgs.autorandr}/bin/autorandr --detected)
     # '';
    };

    desktopManager = {
      xterm.enable = false;
      budgie = { enable = true; }; # Default Desktop Environment
      xfce = {
        enable = true;
        noDesktop = true; 
        enableXfwm = false;
        enableScreensaver = true;
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3lock-color ];
    };
  };
  
  services.fwupd.enable = true; # Firmware updates
  services.hardware.bolt.enable = true; # Thunderbolt daemon
  services.fprintd.enable = false; # Disable fingerprint reader (Overridden in specialisation)
  services.printing.enable = true; # Enable CUPS to print documents.

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
    git # SCM 
    gruvbox-plus-icons-pack # Gruvbox Icons (custom derivation from ../pkgs/)
    gnome.seahorse # Gnome keyring management
  ];

  # Power management
  powerManagement.powertop.enable = true; # View power usage
  services.tlp = { # Laptop power saving utility
    enable = true;
    settings = { 
      PCIE_ASPM_ON_BAT = "powersupersave";
      PCIE_ASPM_ON_AC = "on"; # Force PCIe (i.e. eGPU) devices to "on" when on external power
      };
  };

#  services.logind = {
#    lidSwitch = "ignore";
#    lidSwitchExternalPower = "ignore";
#  };

  programs.zsh.enable = true;
  programs.xfconf.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # See the following for details: https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # Must be false for sync
    powerManagement.finegrained = false; # Must be false for sync
    open = true; # Not working with false (Getting RmInitAdapter failed which could be a bios bug)
    nvidiaSettings = true; # Nvidia Xorg Settings tool
    forceFullCompositionPipeline = true; # Helps with screen tearing
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:4:0:0";
    };
  };

  specialisation = {
    undocked.configuration = {
      system.nixos.tags = [ "undocked" ];
      services.xserver.videoDrivers = lib.mkForce [ "i915" ];
      services.fprintd.enable = lib.mkForce true;
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
      systemd.targets.hybrid-sleep.enable = lib.mkForce true;
      services.logind.lidSwitch = lib.mkForce "suspend-then-hibernate";
      services.logind.lidSwitchExternalPower = lib.mkForce "suspend";
      services.logind.extraConfig = lib.mkForce ''
        IdleAction=hybrid-sleep
        IdleActionSec=1800s
      '';
      systemd.sleep.extraConfig = lib.mkForce ''
        HibernateMode=shutdown
        HibernateDelaySec=1800s
      '';
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
  #services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
