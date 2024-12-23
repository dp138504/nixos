# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  # System-level profiles. Implemented as NixOS modules.
  profiles = {
    virtualization.enable = true; # Enables virtualization technologies: docker & qemu/kvm
    common.enable = true; # Sets common system settings: nix tweaks, i18n, etc.
    bootloader = {
      enable = true; # Bootloader defaults.
      graphical = true; # Enable plymouth graphical boot process.
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  sops = {
    defaultSopsFile = ../../secrets/personal/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    gnupg.home = "../../.git/gnupg";
    secrets = {
      "intermediate_ca.pem" = {  };
      "root_ca.pem" = {  };
    };
  };

  # Bootloader extras.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "usbcore.autosuspend=300" # Suspend USB devices after 5 minutes (default is 2 seconds)
  ];

  networking.hostName = "fw13-nixos"; # Define your hostname.

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager = {
    enable = true;
    enableStrongSwan = true;
  };

  #security.pam.services.lightdm.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pki.certificateFiles = [
    ../../assets/dod_certificates.pem
  ];
  services.pcscd.enable = true; # Smartcard daemon
  services.udev.packages = with pkgs; [
    yubikey-personalization
    platformio-core
    openocd
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.desktopManager.cosmic.enable = false;

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = [ "nvidia" ];
    # Set keyboard layout
    xkb.layout = "us";
    xkb.variant = "";

    desktopManager = {
      xterm.enable = false;
      budgie = {
        enable = true;
      }; # Default Desktop Environment
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

  services.displayManager = {
    defaultSession = "xfce+i3";
    cosmic-greeter.enable = false;
    sddm.enable = true;
    sddm.settings = {
      X11 = {
        DisplayCommand = "${pkgs.autorandr}/bin/autorandr --load $(${pkgs.autorandr}/bin/autorandr --detected)";
      };
    };
    sddm.sugarCandyNix = {
      enable = true;
      settings = {
        Background = lib.cleanSource ../../assets/background_2256x1504.jpg;
        ScreenWidth = 2256;
        ScreenHeight = 1504;
        FormPosition = "left";
        HaveFormBackground = true;
        PartialBlur = true;
        DateFormat = "dddd, MMMM d, yyyy";
        ForceHideCompletePassword = true; # Do not show any password characters
        HeaderText = "";
        Font = "JetBrainsMono Nerd Font Mono";
      };
    };
    # setupCommands = lib.mkAfter ''
    #   ${pkgs.autorandr}/bin/autorandr --load $(${pkgs.autorandr}/bin/autorandr --detected)
    # '';
  };

  environment.budgie.excludePackages = with pkgs; [ nemo ];

  environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';

  services.fwupd.enable = true; # Firmware updates
  services.hardware.bolt.enable = true; # Thunderbolt daemon
  services.fprintd.enable = false; # Disable fingerprint reader (Overridden in specialisation)

  services.printing = {
    enable = true; # Enable CUPS to print documents.
    drivers = [ pkgs.epson-escpr ];
  };

  # Enable sound with pipewire.
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "dialout"
    ];
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
    sops # secrets operations
    git-agecrypt
    gruvbox-plus-icons-pack # Gruvbox Icons (custom derivation from ../pkgs/)
    seahorse # Gnome keyring management
    (pkgs.writeShellScriptBin "setup-browser-cac" ''
      NSSDB="''${HOME}/.pki/nssdb"
      mkdir -p ''${NSSDB}

      ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add p11-kit-proxy \
        -libfile ${pkgs.p11-kit}/lib/p11-kit-proxy.so
    '')
    nfs-utils
  ];

  # Power management
  powerManagement.powertop.enable = true; # View power usage
  services.tlp = {
    # Laptop power saving utility
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
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # See the following for details: https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # Must be false for sync
    powerManagement.finegrained = false; # Must be false for sync
    open = true; # Not working with false (Getting RmInitAdapter failed which could be a bios bug)
    nvidiaSettings = true; # Nvidia Xorg Settings tool
    forceFullCompositionPipeline = true; # Helps with screen tearing
#    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
#      version = "555.58.02";
#      sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
#      sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
#      openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
#      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
#      persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
#    };

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
  #
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
