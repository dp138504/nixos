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
    virtualization = {
      enable = true; # Enables virtualization technologies: docker & qemu/kvm
      addToGroup = [ "dap" ];
    };
    common.enable = true; # Sets common system settings: nix tweaks, i18n, etc.
    bootloader = {
      enable = true; # Bootloader defaults.
      #graphical = true; # Enable plymouth graphical boot process.
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

  #  sops = {
  #    defaultSopsFile = ../../secrets/personal/secrets.yaml;
  #    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  #    gnupg.home = "../../.git/gnupg";
  #    secrets = {
  #      "intermediate_ca.pem" = {  };
  #      "root_ca.pem" = {  };
  #    };
  #  };

  nix.settings.download-buffer-size = 524288000;
  nix.settings.trusted-users = [ "dap" "root" ];

  # Bootloader extras.
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      windows."win11" = {
        title = "Windows 11";
        sortKey = "o_windows";
        efiDeviceHandle = "HD0b";
      };
      # https://github.com/NixOS/nixpkgs/pull/286672#issuecomment-2661087177
      extraInstallCommands = ''
        default_cfg=$(${pkgs.coreutils}/bin/cat /boot/loader/loader.conf | ${pkgs.gnugrep}/bin/grep default | ${pkgs.gawk}/bin/awk '{print $2}')
        tmp=$(${pkgs.coreutils}/bin/mktemp -d)

        ${pkgs.coreutils}/bin/echo -ne "$default_cfg\0" | ${pkgs.iconv}/bin/iconv -f utf-8 -t utf-16le > $tmp/efivar.txt

        ${pkgs.efivar}/bin/efivar -n 4a67b082-0a4c-41cf-b6c7-440b29bb8c4f-LoaderEntryLastBooted -w -f $tmp/efivar.txt
        ${pkgs.systemd}/bin/bootctl set-default @saved
      '';
      extraEntries = {
        "kali.conf" = ''
          title Kali Linux
          efi /efi/edk2-uefi-shell/shell.efi
          options -nointerrupt -nomap -noversion HD1e0b:\EFI\kali\grubx64.efi
          sort-key o_kali
        '';
      };
    };
    kernelParams = [
      "usbcore.autosuspend=300" # Suspend USB devices after 5 minutes (default is 2 seconds)
    ];
  };


#############################
### BEGIN SERVICES CONFIG ###
#############################
  services = {
    automatic-timezoned.enable = true;

    resolved = {
      enable = true;
      fallbackDns = [ ]; # Disable fallback DNS, it messes with internal dns resolution
    };

    nebula.networks.xfits = {
      enable = true;
      lighthouses = [ "100.64.0.1" ];
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      staticHostMap = {
        "100.64.0.1" = [
          "lighthouse.xfits.io:4242"
        ];
      };
      relays = [
        "100.64.0.1"
      ];
      settings.punchy = {
        punch = true;
        respond = true;
      };
      settings.handshakes = {
        try_interval = "100ms";
        retries = 10;
        trigger_buffer = 64;
      };
      settings.preferred_ranges = 
        [
          "192.168.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
        ];
      
      firewall = {
        inbound = [
          {
            host = "dylan-phone";
            port = "22";
            proto = "tcp";
          }
        ];
        outbound = [
          {
            host = "any";
            port = "any";
            proto = "any";
          }
        ];
      };
    };

    udev = {
      packages = with pkgs; [
        yubikey-personalization
        platformio-core
        openocd
        via
      ];
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="4348", ATTR{idProduct}=="7048", ATTR{power/autosuspend}="-1"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="43f2", ATTR{idProduct}=="1211", ATTR{power/autosuspend}="-1" 
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b7f", ATTR{power/autosuspend}="-1" 
        SUBSYSTEMS=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX", GROUP="plugdev"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", TAG+="uaccess"
      '';
    };

    desktopManager = {
      plasma6.enable = true;
      cosmic.enable = true;
    };

    # Enable and configure the X11 windowing system.
    xserver = {
      videoDrivers = [ "nvidia" ];
    };

    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      #    sddm.sugarCandyNix = {
      #      enable = false;
      #      settings = {
      #        Background = lib.cleanSource ../../assets/background_2256x1504.jpg;
      #        ScreenWidth = 2256;
      #        ScreenHeight = 1504;
      #        FormPosition = "left";
      #        HaveFormBackground = true;
      #        PartialBlur = true;
      #        DateFormat = "dddd, MMMM d, yyyy";
      #        ForceHideCompletePassword = true; # Do not show any password characters
      #        HeaderText = "";
      #        Font = "JetBrainsMono Nerd Font Mono";
      #      };
      #    };
    };

    printing = {
      enable = true; # Enable CUPS to print documents.
      drivers = [ pkgs.epson-escpr ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    logind = {
      settings = {
        Login = {
          HandleLidSwitch = "ignore";
          HandleLidSwitchExternalPower = "ignore";
        };
      };
    };

    pcscd.enable = true; # Smartcard daemon
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    udisks2.enable = true;
    fwupd.enable = true; # Firmware updates
    hardware.bolt.enable = true; # Thunderbolt daemon
    fprintd.enable = false; # Disable fingerprint reader (Overridden in specialisation)
    pulseaudio.enable = false; # Disable sound with pulseaudio (to utilize pipewire).
    flatpak.enable = true;
    tailscale.enable = true;
    blueman.enable = true;
    openssh.enable = true;
  };
###########################
### END SERVICES CONFIG ###
###########################

#############################
### BEGIN SECURITY CONFIG ###
#############################
  security = {
    rtkit.enable = true;
    pam.services.hyprlock = { };
    pki.certificateFiles = [
      ../../assets/dod_certificates.pem
      ../../assets/roots.pem
    ];
  };
###########################
### END SECURITY CONFIG ###
###########################

###############################
### BEGIN NETWORKING CONFIG ###
###############################
  networking = {
    hostName = "fw13-nixos"; # Define your hostname.
    wireguard.enable = true;
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-strongswan ];
    };
    firewall = {
      enable = true;
      #allowedTCPPorts = [ ... ];
      #allowedUDPPorts = [ ... ];
      interfaces."nebulx.xfits" = {
        # punt nebula traffic to nebula's firewall
        allowedTCPPortRanges = [
          {
            from = 0;
            to = 65535;
          }
        ];
        allowedUDPPortRanges = [
          {
            from = 0;
            to = 65535;
          }
        ];
      };
    };
  };
#############################
### END NETWORKING CONFIG ###
#############################


  programs = {
    zsh.enable = true;
    xfconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  systemd.mounts = [
    {
      what = "172.16.1.5:/volume1/share";
      type = "nfs";
      where = "/home/dap/mnt/share";
      after = [ "network-online.service" ];
      options = "v4,user,noauto,rw,relatime,nolock";
    }
  ];
  systemd.automounts = [
    {
      name = "home-dap-mnt-share.automount";
      where = "/home/dap/mnt/share";
      wantedBy = [ "multi-user.target" ];
    }
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dap = {
    isNormalUser = true;
    description = "Dylan A Pitts";
    extraGroups = [
      "plugdev"
      "networkmanager"
      "wheel"
      "video"
      "dialout"
      "audio"
      "uucp"
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
    seahorse # Gnome keyring management
    kde-gruvbox
    (pkgs.writeShellScriptBin "setup-browser-cac" ''
      NSSDB="''${HOME}/.pki/nssdb"
      mkdir -p ''${NSSDB}

      ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add p11-kit-proxy \
        -libfile ${pkgs.p11-kit}/lib/p11-kit-proxy.so
    '')
    nfs-utils
    wireguard-tools
  ];

  # Power management
  powerManagement.powertop.enable = true; # View power usage
  #  services.tlp = {
  #    # Laptop power saving utility
  #    enable = true;
  #    settings = {
  #      PCIE_ASPM_ON_BAT = "powersupersave";
  #      PCIE_ASPM_ON_AC = "on"; # Force PCIe (i.e. eGPU) devices to "on" when on external power
  #    };
  #  };

  hardware = {
    rtl-sdr.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # See the following for details: https://nixos.wiki/wiki/Nvidia
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false; # Must be false for sync
      powerManagement.finegrained = false; # Must be false for sync
      open = true; # Not working with false (Getting RmInitAdapter failed which could be a bios bug)
      nvidiaSettings = true; # Nvidia Xorg Settings tool
      forceFullCompositionPipeline = true; # Helps with screen tearing

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "570.133.07";
        sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY="; # this is the third one it will complain is wrong
        sha256_aarch64 = "sha256-2l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM="; # unused
        openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM="; # this is the second one it will complain is wrong
        settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU="; # this is the first one it will complain is wrong
        persistencedSha256 = "sha256-4l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM="; # unused
      };

      prime = {
        sync.enable = true;
        allowExternalGpu = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:4:0:0";
      };
    };
  };

  specialisation = {
    undocked.configuration = {
      system.nixos.tags = [ "undocked" ];
      services.xserver.videoDrivers = lib.mkForce [ "i915" ];
      services.fprintd.enable = lib.mkForce true;
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
      systemd.targets.hybrid-sleep.enable = lib.mkForce true;
      services.logind.settings.Login = lib.mkForce {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend";
        IdleAction = "hybrid-sleep";
        IdleActionSec = "1800s";
      };
      systemd.sleep.extraConfig = lib.mkForce ''
        HibernateMode=shutdown
        HibernateDelaySec=1800s
      '';
    };
  };

  virtualisation.docker.extraOptions = "--iptables=False";

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
